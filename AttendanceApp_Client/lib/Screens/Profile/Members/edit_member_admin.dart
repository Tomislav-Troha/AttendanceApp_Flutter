import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Profile/Employees/employees_admin.dart';
import 'package:swimming_app_client/Screens/Profile/Members/member_controller.dart';
import 'package:swimming_app_client/Screens/Profile/Members/members_admin.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/Widget-Helpers/app_message.dart';

import '../../../Models/user_model.dart';

class EditMemberAdmin extends StatefulWidget {
  late int userID;
  EditMemberAdmin({super.key, required this.userID});

  _EditMemberAdmin createState() => _EditMemberAdmin();
}

class _EditMemberAdmin extends State<EditMemberAdmin> {
   UserResponseModel? user;
  late UserProvider userProvider = UserProvider();
  late MemberAdminController memberAdminController = MemberAdminController();


  void initialize() async {
    ServerResponse getUser = await userProvider.getUserByID(widget.userID);
    if(getUser.isSuccessful){
      user = getUser.result;

      memberAdminController.name.text = user!.name!;
      memberAdminController.surname.text = user!.surname!;
      memberAdminController.adress.text = user!.addres!;
    }
  }

  void updateEmployee() async {
    ServerResponse response = await userProvider.updateUser(memberAdminController.requestModel, widget.userID);
    if(response.isSuccessful){
      AppMessage.showSuccessMessage(message: "Employee updated successfully");
      if(!mounted) return;
      Navigator.pop(context);
    }
    else {
      AppMessage.showErrorMessage(message: response.error);
    }
  }

  @override
  void initState() {

    initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: userProvider.getUserByID(widget.userID),
              builder: (context, future) {
                if (!future.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: memberAdminController.name,
                          decoration: InputDecoration(
                            labelText: "First name",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: memberAdminController.surname,
                          decoration: InputDecoration(
                            labelText: "Last name",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: memberAdminController.adress,
                          decoration: InputDecoration(
                            labelText: "Address",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      TextButton(
                        child: const Text("Save"),
                        onPressed: () async {
                          memberAdminController.requestModel.name =
                              memberAdminController.name.text;
                          memberAdminController.requestModel.surname =
                              memberAdminController.surname.text;
                          memberAdminController.requestModel.addres =
                              memberAdminController.adress.text;

                          updateEmployee();
                        },
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
