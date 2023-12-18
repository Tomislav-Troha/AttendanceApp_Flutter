import 'package:flutter/material.dart';
import 'package:swimming_app_client/Models/change_password_model.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/member_admin_provider.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Profile/Employees/edit_employees_admin.dart';

import '../../../Server/server_response.dart';
import '../../../Widgets/app_message.dart';
import '../../../Widgets/custom_dialog.dart';

class MemberAdmin extends StatefulWidget {
  const MemberAdmin({super.key});

  @override
  _MemberAdmin createState() => _MemberAdmin();
}

class _MemberAdmin extends State<MemberAdmin> {
  UserProvider userProvider = UserProvider();
  ChangePasswordRequestModel changePasswordRequestModel =
      ChangePasswordRequestModel();
  List<UserResponseModel>? users;
  late MemberAdminProvider memberAdminProvider = MemberAdminProvider();

  void getMembers() async {
    ServerResponse allUsersMember = await memberAdminProvider.getUserByMember();
    if (allUsersMember.isSuccessful) {
      users = allUsersMember.result.cast<UserResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allUsersMember.error);
    }
  }

  void deleteUserMember(int id) async {
    ServerResponse response = await memberAdminProvider.deleteUserMember(id);
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: response.result.toString());
    } else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  @override
  void initState() {
    super.initState();

    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Members"),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: FutureBuilder(
            future: memberAdminProvider.getUserByMember(),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else if (future.data!.result.isEmpty) {
                return const Text(
                  "No members",
                  textScaleFactor: 1.6,
                );
              } else {
                List<UserResponseModel>? list = future.data?.result;
                return ListView.builder(
                  itemCount: list!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                title:
                                    "${list[index].name!} ${list[index].surname}",
                                message: "",
                                children: [
                                  TextButton(
                                    child: const Text("Edit"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) {
                                        return EditEmployeeAdmin(
                                            userID: list[index].userId!);
                                      }));
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Reset password"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialog(
                                            title: "Reset password",
                                            message:
                                                "Do you really want reset password for user ${list[index].name!} ${list[index].surname}?",
                                            children: [
                                              TextButton(
                                                child: const Text("Yes"),
                                                onPressed: () async {
                                                  changePasswordRequestModel
                                                          .email =
                                                      list[index].email!;
                                                  changePasswordRequestModel
                                                      .password = "123";
                                                  await userProvider
                                                      .changePassword(
                                                          changePasswordRequestModel)
                                                      .then((value) => {
                                                            AppMessage
                                                                .showSuccessMessage(
                                                                    message:
                                                                        "Password reset successfully")
                                                          })
                                                      .catchError((error) {
                                                    AppMessage.showErrorMessage(
                                                        message:
                                                            error.toString());
                                                  }).whenComplete(() => {
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                            })
                                                          });
                                                },
                                              ),
                                              TextButton(
                                                child: const Text("Ne"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      deleteUserMember(list[index].userId!);
                                      setState(() {
                                        Navigator.pop(context);
                                        list.removeAt(index);
                                      });
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        onLongPress: () {},
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              title: Text(
                                "${list[index].name!} ${list[index].surname!}",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                  list[index].userRoleModel!.roleDesc == null
                                      ? "Role not set"
                                      : list[index].userRoleModel!.roleDesc!),
                            ),
                          ),
                        ));
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
