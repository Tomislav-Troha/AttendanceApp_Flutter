import 'package:flutter/material.dart';
import 'package:swimming_app_client/Models/contract_model.dart';
import 'package:swimming_app_client/Models/contract_type_model.dart';
import 'package:swimming_app_client/Models/job_role_model.dart';
import 'package:swimming_app_client/Models/salary_package_type_model.dart';
import 'package:swimming_app_client/Models/userRole_model.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/contract_provider.dart';
import 'package:swimming_app_client/Provider/user_role_provider.dart';
import 'package:swimming_app_client/Screens/Profile/SetUserRole/userRole_controller.dart';

import '../../../Widgets/app_message.dart';
import '../../../Widgets/custom_dialog.dart';
import '../../../Widgets/custom_dropdown_button.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../../server_helper/server_response.dart';

class SetUserRole extends StatefulWidget {
  const SetUserRole({super.key});

  @override
  _SetUserRole createState() => _SetUserRole();
}

class _SetUserRole extends State<SetUserRole> {
  late List<UserResponseModel> users;
  List<UserRoleResponseModel>? userRoles;
  List<ContractTypeResponseModel>? valueContractType;
  List<SalaryPackageTypeResponseModel>? valueSalaryPackage;
  List<JobRoleResponseModel>? valueJobRole;
  late UserRoleProvider userRoleProvider = UserRoleProvider();
  late ContractProvider contractProvider = ContractProvider();

  UserRoleResponseModel? _valueUserRole;
  ContractTypeResponseModel? _valueContractType;
  SalaryPackageTypeResponseModel? _valueSalaryPackage;
  JobRoleResponseModel? _valueJobRole;

  bool isNotMemberSelected = false;

  List<UserRoleResponseModel>? listUserRole;

  void getUserRoles() async {
    ServerResponse response = await userRoleProvider.getUserRoles();
    if (response.isSuccessful) {
      userRoles = response.result.cast<UserRoleResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  void getUserNoSet() async {
    var allUsersWithNotSetRole = await userRoleProvider.getUserRoleNotSet();
    if (allUsersWithNotSetRole.isSuccessful) {
      users = allUsersWithNotSetRole.result.cast<UserResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allUsersWithNotSetRole.error);
    }
  }

  void addUserRole(int id, ContractRequestModel model) async {
    ServerResponse response = await userRoleProvider.addUserRole(model, id);
    if (response.isSuccessful) {
      AppMessage.showSuccessMessage(message: response.result.toString());
      setState(() {
        Navigator.pop(context);
      });
    } else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  void getContractType() async {
    var allContractTypes = await contractProvider.getContractType();
    if (allContractTypes.isSuccessful) {
      valueContractType =
          allContractTypes.result.cast<ContractTypeResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allContractTypes.error);
    }
  }

  void getJobRoles() async {
    var allJobRoles = await contractProvider.getJobRoles();
    if (allJobRoles.isSuccessful) {
      valueJobRole = allJobRoles.result.cast<JobRoleResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allJobRoles.error);
    }
  }

  void getSalaryPackage() async {
    var allSalaryPackage = await contractProvider.getSalaryPackageTypes();
    if (allSalaryPackage.isSuccessful) {
      valueSalaryPackage =
          allSalaryPackage.result.cast<SalaryPackageTypeResponseModel>();
    } else {
      AppMessage.showErrorMessage(message: allSalaryPackage.error);
    }
  }

  @override
  void initState() {
    super.initState();

    getUserRoles();
    getContractType();
    getJobRoles();
    getSalaryPackage();
  }

  late UserRoleController userRoleController = UserRoleController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Set user role"),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: FutureBuilder(
            future: userRoleProvider.getUserRoleNotSet(),
            builder: (context, future) {
              if (!future.hasData) {
                return const CircularProgressIndicator();
              } else if (future.data!.result.isEmpty) {
                return const Text(
                  "No new users",
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
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return CustomDialog(
                                    title:
                                        "${list[index].name} ${list[index].surname}",
                                    message: "",
                                    children: [
                                      Column(
                                        children: [
                                          CustomDropdownButton(
                                            label: "Please select role",
                                            hint: 'Role',
                                            items: userRoles!.map<
                                                    DropdownMenuItem<
                                                        UserRoleResponseModel>>(
                                                (UserRoleResponseModel?
                                                    values) {
                                              return DropdownMenuItem<
                                                  UserRoleResponseModel>(
                                                value: values!,
                                                child: SizedBox(
                                                  width: 140.0,
                                                  child: Text(values.roleDesc!),
                                                ),
                                                onTap: () {},
                                              );
                                            }).toList(),
                                            value: _valueUserRole,
                                            onChanged: (value) {
                                              setState(() {
                                                _valueUserRole = value;
                                                userRoleController.requestModel
                                                        .userRoleModel?.roleID =
                                                    _valueUserRole!.roleID;

                                                isNotMemberSelected =
                                                    _valueUserRole!.roleDesc !=
                                                        "Member";
                                              });
                                            },
                                          ),
                                          if (isNotMemberSelected) ...[
                                            CustomDropdownButton(
                                              label:
                                                  "Please select contract type",
                                              hint: 'Contract type',
                                              items: valueContractType!.map<
                                                      DropdownMenuItem<
                                                          ContractTypeResponseModel>>(
                                                  (ContractTypeResponseModel?
                                                      values) {
                                                return DropdownMenuItem<
                                                    ContractTypeResponseModel>(
                                                  value: values!,
                                                  child: SizedBox(
                                                    width: 140.0,
                                                    child: Text(values
                                                        .contractTypeName!),
                                                  ),
                                                  onTap: () {},
                                                );
                                              }).toList(),
                                              value: _valueContractType,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueContractType = value;
                                                  userRoleController
                                                          .requestModel
                                                          .contractTypeModel
                                                          ?.contractTypeID =
                                                      _valueContractType
                                                          ?.contractTypeID;
                                                });
                                              },
                                            ),
                                            CustomDropdownButton(
                                              label: "Please salary package",
                                              hint: 'Salary package',
                                              items: valueSalaryPackage!.map<
                                                      DropdownMenuItem<
                                                          SalaryPackageTypeResponseModel>>(
                                                  (SalaryPackageTypeResponseModel?
                                                      values) {
                                                return DropdownMenuItem<
                                                    SalaryPackageTypeResponseModel>(
                                                  value: values!,
                                                  child: SizedBox(
                                                    width: 140.0,
                                                    child: Text(values
                                                        .salaryPackageName!),
                                                  ),
                                                  onTap: () {},
                                                );
                                              }).toList(),
                                              value: _valueSalaryPackage,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueSalaryPackage = value;
                                                  userRoleController
                                                          .requestModel
                                                          .salaryPackageTypeModel
                                                          ?.salaryPackageID =
                                                      _valueSalaryPackage
                                                          ?.salaryPackageID;
                                                });
                                              },
                                            ),
                                            CustomDropdownButton(
                                              label: "Please select job role",
                                              hint: 'Job role',
                                              items: valueJobRole!.map<
                                                      DropdownMenuItem<
                                                          JobRoleResponseModel>>(
                                                  (JobRoleResponseModel?
                                                      values) {
                                                return DropdownMenuItem<
                                                    JobRoleResponseModel>(
                                                  value: values!,
                                                  child: SizedBox(
                                                    width: 140.0,
                                                    child: Text(
                                                        values.jobRoleName!),
                                                  ),
                                                  onTap: () {},
                                                );
                                              }).toList(),
                                              value: _valueJobRole,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueJobRole = value;
                                                  userRoleController
                                                          .requestModel
                                                          .jobRoleModel
                                                          ?.jobRoleID =
                                                      _valueJobRole?.jobRoleID;
                                                });
                                              },
                                            ),
                                            CustomTextFormField(
                                                controller:
                                                    userRoleController.dateFrom,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                onTap: () {
                                                  userRoleController.selectDate(
                                                      context, true);
                                                },
                                                readOnly: true,
                                                labelText: 'Start date',
                                                prefixIcon: Icons.date_range),
                                            CustomTextFormField(
                                                controller:
                                                    userRoleController.dateTo,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                onTap: () {
                                                  userRoleController.selectDate(
                                                      context, false);
                                                },
                                                readOnly: true,
                                                labelText: 'End date',
                                                prefixIcon: Icons.date_range),
                                          ],
                                          TextButton(
                                            child: const Text("Save"),
                                            onPressed: () {
                                              if (userRoleController
                                                      .roleID.text !=
                                                  "0") {
                                                addUserRole(
                                                    list[index].userId!,
                                                    userRoleController
                                                        .requestModel);
                                              } else {
                                                AppMessage.showErrorMessage(
                                                    message:
                                                        "Please select role");
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        onLongPress: () {},
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${list[index].name!} ${list[index].surname!}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(list[index].userRoleModel!.roleDesc == null
                                    ? "Role not set"
                                    : list[index].userRoleModel!.roleDesc!)
                              ],
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
