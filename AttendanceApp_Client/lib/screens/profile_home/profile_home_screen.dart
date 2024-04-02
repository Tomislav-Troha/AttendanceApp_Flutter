import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/controllers/profile_controller/profile_controller.dart';
import 'package:swimming_app_client/enums/user_roles.dart';
import 'package:swimming_app_client/managers/token_manager.dart';
import 'package:swimming_app_client/screens/profile/edit_profile.dart';

import '../../../constants.dart';
import '../../../models/contract_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/contract_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../server_helper/server_response.dart';
import '../../../widgets/app_message.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_expansion_tile.dart';
import '../../../widgets/sensitive_info_toggle.dart';
import '../login/login_screen.dart';
import '../profile/admin_panel_screen/admin_panel_screen.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  final ProfileController _controller = ProfileController();
  final PageStorageBucket _bucket = PageStorageBucket();

  final UserRequestModel _userRequestModel = UserRequestModel();
  final UserProvider _userProvider = UserProvider();
  final ContractProvider _contractProvider = ContractProvider();
  late Future<ServerResponse> _userDataFuture;
  late Future<ServerResponse> _contractByUserIdFuture;
  Map<String, dynamic> _token = {};
  UserResponseModel _userModel = UserResponseModel();

  int? _userID;
  int? _userRoleID;

  bool _isVisibleAdmin = true;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  static Map<String, UserResponseModel> userCache = {};

  Future<Uint8List?> _getXFileBytes(XFile? file) async {
    if (file == null) return null;
    final bytes = await File(file.path).readAsBytes();
    return bytes;
  }

  void _getUserData() async {
    ServerResponse serverResponse =
        await _userProvider.getUserByID(int.parse(_token["UserID"]));
    if (serverResponse.isSuccessful) {
      userCache.clear();
      _userModel = serverResponse.result;
      setState(() {});
    }
  }

  void _initialize() async {
    _token = await TokenManager.getTokenUserRole();

    _initializeTokenInfo();

    if (_token["UserRoleId"] == UserRoles.Member) {
      _isVisibleAdmin = false;
    } else {
      _isVisibleAdmin = true;
    }
    var cachedUser = userCache[_token["UserID"]];

    if (cachedUser == null) {
      ServerResponse users = await _userProvider.getUserByID(_userID);
      if (users.isSuccessful) {
        _userModel = users.result;
        userCache[_token["UserID"]] = _userModel;
      } else {
        AppMessage.showErrorMessage(
            message: "Error loading user data ${users.error}");
      }
    } else {
      _userModel = cachedUser;
    }
    _userDataFuture = _userProvider.getUserByID(_userModel.userId!);
    _contractByUserIdFuture =
        _contractProvider.getContractsByUserId(_userModel.userId!);
  }

  Future _insertImage(ImageSource media) async {
    _image = await _picker.pickImage(source: media);
    var imgBytes = await _getXFileBytes(_image);

    _userRequestModel.profileImage = imgBytes;
    ServerResponse response = await _userProvider.setProfileImage(
        _userRequestModel, int.parse(_token["UserID"]));
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: "Image successfully uploaded");
    } else {
      AppMessage.showErrorMessage(
          message: "Error uploading image ${response.error}");
    }

    if (imgBytes != null) {
      // cache the new image
      userCache[_token["UserID"]]?.profileImage = imgBytes;
    }
    //update the UI after the image is loaded
    setState(() {});
  }

  Uint8List? _getCachedImage() {
    return userCache[_token["UserID"]]?.profileImage;
  }

  Future<ContractResponseModel?> _getContractByUserId(int id) async {
    var contractByUserId = await _contractProvider.getContractsByUserId(id);
    if (contractByUserId.isSuccessful) {
      if (contractByUserId.result.isNotEmpty) {
        return contractByUserId.result.first;
      }
      return null;
    } else {
      AppMessage.showErrorMessage(
          message: "Error loading contract data ${contractByUserId.error}");
      return null;
    }
  }

  void _initializeTokenInfo() async {
    _userID = int.parse(_token["UserID"]);
    _userRoleID = int.parse(_token["UserRoleId"]);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return PageStorage(
              bucket: _bucket,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding,
                  horizontal: defaultPadding,
                ),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding,
                            horizontal: defaultPadding,
                          ),
                          child: Column(children: [
                            FutureBuilder<ServerResponse>(
                              future: _contractByUserIdFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot<ServerResponse> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('No data available');
                                } else {
                                  ContractResponseModel contract =
                                      snapshot.data!.result;
                                  return Column(
                                    children: [
                                      CustomExpansionTile(
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${_userModel.name!} ${_userModel.surname!}",
                                              textScaleFactor: 1.5,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "Contract Type",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14),
                                            ),
                                            subtitle: Text(
                                              contract.contractTypeModel
                                                      ?.contractTypeName ??
                                                  contract
                                                      .userRoleModel!.roleName!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          if (_userModel
                                                  .userRoleModel?.roleID !=
                                              int.parse(UserRoles.Member)) ...[
                                            ListTile(
                                              title: Text(
                                                "Salary Package",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14),
                                              ),
                                              subtitle: SensitiveInfoToggle(
                                                sensitiveInfo: contract
                                                        .salaryPackageTypeModel
                                                        ?.salaryPackageName ??
                                                    '',
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Job Role",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                contract.jobRoleModel
                                                        ?.jobRoleName ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Date From",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                DateFormat('dd.MM.yyyy').format(
                                                    contract.startDate!
                                                        .toLocal()),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(
                                                "Expiry Date",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                DateFormat('dd.MM.yyyy').format(
                                                    contract.expiryDate!
                                                        .toLocal()),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      )
                                    ],
                                  );
                                }
                              },
                            )
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding,
                              horizontal: defaultPadding),
                          child: Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(100.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100.0),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialog(
                                              title: "Profile picture",
                                              message: "",
                                              children: [
                                                TextButton(
                                                    child: const Text(
                                                        "Get image from gallery"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _insertImage(
                                                          ImageSource.gallery);
                                                    }),
                                                TextButton(
                                                    child: const Text(
                                                        "Get image from camera"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _insertImage(
                                                          ImageSource.camera);
                                                    })
                                              ],
                                            );
                                          });
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: _getCachedImage() != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: Image.memory(
                                                _getCachedImage()!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : _userModel.profileImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: Image.memory(
                                                    _userModel!.profileImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                      Icons
                                                          .photo_camera_front_rounded,
                                                      size: 100),
                                                ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                      Flexible(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding,
                                  horizontal: defaultPadding),
                              child: ElevatedButton(
                                child: const Text("Edit profile"),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EditProfileScreen(
                                          userCache: userCache,
                                          callback: _getUserData,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: _isVisibleAdmin,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding,
                                    horizontal: defaultPadding),
                                child: ElevatedButton(
                                  child: const Text("Admin panel"),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const AdminPanelScreen();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding,
                                  horizontal: defaultPadding),
                              child: ElevatedButton(
                                child: const Text("Change password"),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        _controller.changePasswordEmail.text =
                                            _userModel!.email!;
                                        final formKey1 = GlobalKey<FormState>();
                                        return ScaffoldMessenger(
                                          child: Builder(builder: (context) {
                                            return Scaffold(
                                              backgroundColor:
                                                  Colors.transparent,
                                              body: CustomDialog(
                                                title: "Change password",
                                                message: "",
                                                children: [
                                                  Form(
                                                    key: formKey1,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller: _controller
                                                              .changePasswordEmail,
                                                          validator: (value) {
                                                            if (_controller
                                                                .changePasswordEmail
                                                                .text
                                                                .isEmpty) {
                                                              return 'Please enter email';
                                                            }
                                                            return null;
                                                          },
                                                          // cursorColor: kPrimaryColor,
                                                          decoration:
                                                              InputDecoration(
                                                            floatingLabelStyle:
                                                                MaterialStateTextStyle
                                                                    .resolveWith(
                                                                        (Set<MaterialState>
                                                                            states) {
                                                              final Color color = states
                                                                      .contains(
                                                                          MaterialState
                                                                              .error)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error
                                                                  : Colors
                                                                      .black;
                                                              return TextStyle(
                                                                  color: color,
                                                                  letterSpacing:
                                                                      1.3);
                                                            }),
                                                            labelText: "Email",
                                                            prefixIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      defaultPadding),
                                                              child: Icon(
                                                                  Icons.email),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        TextFormField(
                                                          controller:
                                                              _controller
                                                                  .newPassword,
                                                          obscureText: true,
                                                          validator: (value) {
                                                            if (_controller
                                                                .newPassword
                                                                .text
                                                                .isEmpty) {
                                                              return 'Please enter new password';
                                                            }
                                                            if (_controller
                                                                    .apiErrors !=
                                                                null) {
                                                              return _controller
                                                                  .apiErrors;
                                                            }
                                                            return null;
                                                          },
                                                          // cursorColor: kPrimaryColor,
                                                          decoration:
                                                              InputDecoration(
                                                            floatingLabelStyle:
                                                                MaterialStateTextStyle
                                                                    .resolveWith(
                                                                        (Set<MaterialState>
                                                                            states) {
                                                              final Color color = states
                                                                      .contains(
                                                                          MaterialState
                                                                              .error)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error
                                                                  : Colors
                                                                      .black;
                                                              return TextStyle(
                                                                  color: color,
                                                                  letterSpacing:
                                                                      1.3);
                                                            }),
                                                            labelText:
                                                                "New password",
                                                            prefixIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      defaultPadding),
                                                              child: Icon(
                                                                  Icons.lock),
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                            child: const Text(
                                                              "Change password",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              _controller
                                                                  .clearApiErrorMessage();

                                                              if (formKey1
                                                                  .currentState!
                                                                  .validate()) {
                                                                _controller
                                                                        .changePasswordRequestModel
                                                                        .email =
                                                                    _controller
                                                                        .changePasswordEmail
                                                                        .text;
                                                                _controller
                                                                        .changePasswordRequestModel
                                                                        .password =
                                                                    _controller
                                                                        .newPassword
                                                                        .text;

                                                                var dateProviderLogin =
                                                                    await _userProvider
                                                                        .changePassword(
                                                                            _controller.changePasswordRequestModel);

                                                                if (!mounted)
                                                                  return;
                                                                if (dateProviderLogin
                                                                        .success ==
                                                                    true) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return CustomDialog(
                                                                          title:
                                                                              "Password changed",
                                                                          message:
                                                                              '',
                                                                          children: [
                                                                            TextButton(
                                                                              child: const Text("Log out"),
                                                                              onPressed: () {
                                                                                TokenManager.clearPrefs();
                                                                                if (!mounted) return;
                                                                                Navigator.pushReplacement(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) {
                                                                                      return const LoginScreen();
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },
                                                                            )
                                                                          ],
                                                                        );
                                                                      });
                                                                } else {
                                                                  List? error =
                                                                      dateProviderLogin
                                                                          .errors;
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          error!
                                                                              .length;
                                                                      i++) {
                                                                    _controller
                                                                            .apiErrors =
                                                                        error[
                                                                            i];
                                                                    formKey1
                                                                        .currentState!
                                                                        .validate();
                                                                  }
                                                                }
                                                              }
                                                            }),
                                                        TextButton(
                                                          child: const Text(
                                                              "Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                        );
                                      });
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
