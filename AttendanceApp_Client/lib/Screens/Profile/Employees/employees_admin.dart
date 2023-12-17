import 'package:flutter/material.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/employee_admin_provider.dart';
import 'package:swimming_app_client/Screens/Profile/Members/edit_member_admin.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../../Enums/EnumUserRoles.dart';
import '../../../Managers/token_manager.dart';
import '../../../Widgets/app_message.dart';
import '../../../Widgets/custom_dialog.dart';

class EmployeeAdmin extends StatefulWidget {
  @override
  _EmployeeAdmin createState() => _EmployeeAdmin();
}

class _EmployeeAdmin extends State<EmployeeAdmin> {
  late List<UserResponseModel> users;
  late EmployeeAdminProvider employeeAdminProvider = EmployeeAdminProvider();

  void getAllUsersForEmployee() async {
    ServerResponse allUsersEmployee =
        await employeeAdminProvider.getUserEmployee();
    users = allUsersEmployee.result.cast<UserResponseModel>();
  }

  void deleteUserEmployee(int id) async {
    var response = await employeeAdminProvider.deleteUserEmployee(id);
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: "Employee deleted");
      if (!mounted) return;
      setState(() {
        Navigator.pop(context);
      });
    } else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  @override
  void initState() {
    super.initState();

    getAllUsersForEmployee();
  }

  Map<String, dynamic> token = TokenManager().getTokenUserRole();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Employees"),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: FutureBuilder(
            future: employeeAdminProvider.getUserEmployee(),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else if (future.data!.result.isEmpty) {
                return const Text(
                  "There is no employees yet",
                  textScaleFactor: 1.6,
                );
              } else {
                List<UserResponseModel>? list =
                    future.data?.result.cast<UserResponseModel>();
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
                                      if (token["UserRoleId"] ==
                                              EnumUserRole.Admin ||
                                          token["UserRoleId"] ==
                                              EnumUserRole.Moderator) {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EditMemberAdmin(
                                              userID: list[index].userId!);
                                        }));
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Only admin or moderator can edit employees",
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      "Obriši",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      if (token["UserRoleId"] ==
                                              EnumUserRole.Admin ||
                                          token["UserRoleId"] ==
                                              EnumUserRole.Moderator) {
                                        deleteUserEmployee(list[index].userId!);
                                        setState(() {
                                          list.removeAt(index);
                                        });
                                      } else {
                                        AppMessage.showErrorMessage(
                                            message:
                                                "Only admin or moderator can delete employees");
                                      }
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
                            )));
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
