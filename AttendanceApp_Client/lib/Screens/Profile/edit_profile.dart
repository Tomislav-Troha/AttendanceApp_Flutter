import 'package:flutter/material.dart';
import 'package:swimming_app_client/Models/user_model.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Server/server_response.dart';
import 'package:swimming_app_client/Widget-Helpers/app_message.dart';

import '../../Managers/token_manager.dart';

class EditProfile extends StatefulWidget {

  Map<String, UserResponseModel> userCache;
  final VoidCallback? callback;

  EditProfile({super.key, required this.userCache, this.callback});

  createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  final UserRequestModel userRequestModel = UserRequestModel();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  UserProvider userProvider = UserProvider();
  late Map<String, dynamic> token;

  void initialize() async {

    token = TokenManager().getTokenUserRole();
    ServerResponse users = await userProvider.getUserByID(int.parse(token["UserID"]));

    setState(() {
      _firstNameController.text = users.result.name!;
      _lastNameController.text = users.result.surname!;
      _addressController.text = users.result.addres!;
    });
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
            title: const Text("Edit profile"),
            automaticallyImplyLeading: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {

                        userRequestModel.name = _firstNameController.text;
                        userRequestModel.surname = _lastNameController.text;
                        userRequestModel.addres = _addressController.text;

                        widget.userCache.remove(token["UserID"]);

                        ServerResponse response = await userProvider.updateUser(userRequestModel, int.parse(token["UserID"]));
                        if(response.isSuccessful){
                          FocusManager.instance.primaryFocus?.unfocus();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            AppMessage.showSuccessMessage(message: "Profile is successfully edited");
                            if(!mounted) return;
                            // Navigator.pop(context);
                            widget.callback!();
                          });
                        }
                        else {
                          AppMessage.showErrorMessage(message: response.error.toString(), duration: 5);
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
