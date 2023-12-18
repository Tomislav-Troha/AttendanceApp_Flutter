import 'package:flutter/material.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Profile/Members/member_controller.dart';
import 'package:swimming_app_client/Screens/Profile/Members/members_admin.dart';
import 'package:swimming_app_client/Server/server_response.dart';

import '../../../Models/user_model.dart';
import '../../../Widgets/app_message.dart';

class EditEmployeeAdmin extends StatefulWidget {
  const EditEmployeeAdmin({super.key, required this.userID});
  final int userID;
  @override
  State<StatefulWidget> createState() => _EditEmployeeAdmin();
}

class _EditEmployeeAdmin extends State<EditEmployeeAdmin> {
  late UserResponseModel user;
  late UserProvider userProvider = UserProvider();
  late MemberAdminController memberAdminController = MemberAdminController();

  void initialize() async {
    ServerResponse getUser = await userProvider.getUserByID(widget.userID);
    if (getUser.isSuccessful) {
      user = getUser.result;

      memberAdminController.name.text = user.name!;
      memberAdminController.surname.text = user.surname!;
      memberAdminController.adress.text = user.addres!;
    } else {
      AppMessage.showErrorMessage(message: "Error while loading user data");
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
          title: const Text("Uredi"),
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
                            labelText: "Ime",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                          cursorColor: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: memberAdminController.surname,
                          decoration: InputDecoration(
                            labelText: "Prezime",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                          cursorColor: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          controller: memberAdminController.adress,
                          decoration: InputDecoration(
                            labelText: "Adresa",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                          cursorColor: Colors.blue,
                          onTap: () {},
                        ),
                      ),
                      TextButton(
                        child: const Text("Spremi"),
                        onPressed: () async {
                          memberAdminController.requestModel.name =
                              memberAdminController.name.text;
                          memberAdminController.requestModel.surname =
                              memberAdminController.surname.text;
                          memberAdminController.requestModel.addres =
                              memberAdminController.adress.text;

                          await userProvider
                              .updateUser(memberAdminController.requestModel,
                                  widget.userID)
                              .then((value) => {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                      return MemberAdmin();
                                    })),
                                    AppMessage.showSuccessMessage(
                                        message: "Član ažuriran!")
                                  })
                              .catchError((error) {
                            AppMessage.showErrorMessage(
                                message: error.toString());
                          });
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
