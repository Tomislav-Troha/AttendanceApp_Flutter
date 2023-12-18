import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swimming_app_client/Managers/token_manager.dart';
import 'package:swimming_app_client/Models/contract_model.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/contract_provider.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/ProfileHome/profile_controller.dart';
import 'package:swimming_app_client/Screens/Profile/AdminProfile/profile_admin.dart';
import 'package:swimming_app_client/Screens/Profile/edit_profile.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../../Enums/EnumUserRoles.dart';
import '../../../Widgets/app_message.dart';
import '../../../Widgets/custom_dialog.dart';
import '../../../Widgets/custom_expansion_tile.dart';
import '../../../Widgets/sensitive_info_toggle.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController controller = ProfileController();
  final PageStorageBucket bucket = PageStorageBucket();
  bool _isVisibleAdmin = true;
  bool isBlurred = true;

  late Future<UserResponseModel> userResponseModel;
  UserResponseModel? userModel;
  UserRequestModel userRequestModel = UserRequestModel();
  UserProvider userProvider = UserProvider();
  ContractProvider contractProvider = ContractProvider();
  List<ContractResponseModel> contractModel = [];

  bool isMember = false;
  XFile? image;
  final ImagePicker picker = ImagePicker();

  late Map<String, dynamic> token;

  static Map<String, UserResponseModel> userCache = {};

  Future<Uint8List?> getXFileBytes(XFile? file) async {
    if (file == null) return null;
    final bytes = await File(file.path).readAsBytes();
    return bytes;
  }

  void getUserData() async {
    ServerResponse serverResponse =
        await userProvider.getUserByID(int.parse(token["UserID"]));
    if (serverResponse.isSuccessful) {
      userCache.clear();
      userModel = serverResponse.result;
      setState(() {});
    }
  }

  void initializeUserModel() async {
    token = TokenManager().getTokenUserRole();
    var cachedUser = userCache[token["UserID"]];

    if (cachedUser == null) {
      ServerResponse users =
          await userProvider.getUserByID(int.parse(token["UserID"]));
      if (users.isSuccessful) {
        userModel = users.result;
        if (userModel != null) {
          userCache[token["UserID"]] = userModel!;
        }
      } else {
        AppMessage.showErrorMessage(
            message: "Error loading user data ${users.error}");
      }
    } else {
      userModel = cachedUser;
    }
  }

  Future insertImage(ImageSource media) async {
    image = await picker.pickImage(source: media);
    var imgBytes = await getXFileBytes(image);

    userRequestModel.profileImage = imgBytes;
    ServerResponse response = await userProvider.setProfileImage(
        userRequestModel, int.parse(token["UserID"]));
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: "Image successfully uploaded");
    } else {
      AppMessage.showErrorMessage(
          message: "Error uploading image ${response.error}");
    }

    if (imgBytes != null) {
      // cache the new image
      userCache[token["UserID"]]?.profileImage = imgBytes;
    }
    //update the UI after the image is loaded
    setState(() {});
  }

  Uint8List? getCachedImage() {
    return userCache[token["UserID"]]?.profileImage;
  }

  Future<ContractResponseModel?> getContractByUserId(int id) async {
    var contractByUserId = await contractProvider.getContractsByUserId(id);
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

  @override
  void initState() {
    super.initState();

    initializeUserModel();

    if (token["UserRoleId"] == EnumUserRole.Member) {
      _isVisibleAdmin = false;
    } else {
      _isVisibleAdmin = true;
    }
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
        future: userProvider.getUserByID(int.parse(token["UserID"])),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return PageStorage(
              bucket: bucket,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding,
                              horizontal: defaultPadding),
                          child: Column(children: [
                            FutureBuilder<ContractResponseModel?>(
                              future: getContractByUserId(
                                  int.parse(token["UserID"])),
                              builder: (BuildContext context,
                                  AsyncSnapshot<ContractResponseModel?>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  ); // Show a loader while waiting for data
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('No data available');
                                } else {
                                  ContractResponseModel contract =
                                      snapshot.data!;
                                  return Column(
                                    children: [
                                      CustomExpansionTile(
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${userModel?.name!} ${userModel?.surname!}",
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
                                          if (userModel
                                                  ?.userRoleModel?.roleID !=
                                              int.parse(
                                                  EnumUserRole.Member)) ...[
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
                                                      insertImage(
                                                          ImageSource.gallery);
                                                    }),
                                                TextButton(
                                                    child: const Text(
                                                        "Get image from camera"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      insertImage(
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
                                      child: getCachedImage() != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              child: Image.memory(
                                                getCachedImage()!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : userModel?.profileImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: Image.memory(
                                                    userModel!.profileImage!,
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
                                      MaterialPageRoute(builder: (context) {
                                    return EditProfile(
                                        userCache: userCache,
                                        callback: getUserData);
                                  }));
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
                                        MaterialPageRoute(builder: (context) {
                                      return ProfileAdmin();
                                    }));
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
                                        controller.changePasswordEmail.text =
                                            userModel!.email!;
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
                                                          controller: controller
                                                              .changePasswordEmail,
                                                          validator: (value) {
                                                            if (controller
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
                                                          controller: controller
                                                              .newPassword,
                                                          obscureText: true,
                                                          validator: (value) {
                                                            if (controller
                                                                .newPassword
                                                                .text
                                                                .isEmpty) {
                                                              return 'Please enter new password';
                                                            }
                                                            if (controller
                                                                    .apiErrors !=
                                                                null) {
                                                              return controller
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
                                                              controller
                                                                  .clearApiErrorMessage();

                                                              if (formKey1
                                                                  .currentState!
                                                                  .validate()) {
                                                                controller
                                                                        .changePasswordRequestModel
                                                                        .email =
                                                                    controller
                                                                        .changePasswordEmail
                                                                        .text;
                                                                controller
                                                                        .changePasswordRequestModel
                                                                        .password =
                                                                    controller
                                                                        .newPassword
                                                                        .text;

                                                                var dateProviderLogin =
                                                                    await userProvider
                                                                        .changePassword(
                                                                            controller.changePasswordRequestModel);

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
                                                                    controller
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
