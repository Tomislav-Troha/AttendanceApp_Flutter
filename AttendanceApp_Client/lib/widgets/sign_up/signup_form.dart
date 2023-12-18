import 'package:flutter/material.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/constants.dart';

import '../../Models/register_model.dart';
import '../../controllers/sign_up/signup_controller.dart';
import '../app_message.dart';
import '../custom_dialog.dart';
import '../custom_text_button.dart';
import '../screen_navigator.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final SignupController _registerController = SignupController();
  final _formKey = GlobalKey<FormState>();
  final UserProvider _userProvider = UserProvider();

  void _registerSucceeded(RegisterResponseModel dataRegisterProvider) {
    if (dataRegisterProvider.success == true) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: "Registration succeeded",
            message: "Contact your superior for account activation",
            children: [
              CustomTextButton(
                text: "Ok",
                textSize: 20,
                onPressed: () {
                  ScreenNavigator.navigateToScreen(context, const LoginScreen(),
                      pushReplacement: true);
                },
              ),
            ],
          );
        },
      );
    } else {
      List? error = dataRegisterProvider.errors;
      if (error != null && error.isNotEmpty) {
        String concatenatedErrors = error.join('\n');
        AppMessage.showErrorMessage(message: concatenatedErrors);
      } else {
        AppMessage.showErrorMessage(message: "An unknown error occurred.");
      }
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var dataRegisterProvider = await _userProvider.register(
          _registerController.requestModel, context);

      if (!mounted) return;
      _registerSucceeded(dataRegisterProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration getInputDecoration(String label, IconData icon) {
      return InputDecoration(
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : Colors.black;
            return TextStyle(color: color, letterSpacing: 1.3);
          },
        ),
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Icon(icon),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              controller: _registerController.emailController,
              validator: (value) {
                if (_registerController.emailController.text.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (email) {
                _registerController.requestModel.email = email;
              },
              decoration: getInputDecoration("E-mail", Icons.email),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              controller: _registerController.nameController,
              validator: (value) {
                if (_registerController.nameController.text.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onSaved: (firstName) {
                _registerController.requestModel.name = firstName;
              },
              decoration: getInputDecoration(
                  "First name", Icons.drive_file_rename_outline_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              controller: _registerController.surnameController,
              validator: (value) {
                if (_registerController.surnameController.text.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved: (lastName) {
                _registerController.requestModel.surname = lastName;
              },
              decoration: getInputDecoration(
                  "Last name", Icons.drive_file_rename_outline_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              controller: _registerController.addressController,
              validator: (value) {
                if (_registerController.addressController.text.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              onSaved: (address) {
                _registerController.requestModel.addres = address;
              },
              decoration: getInputDecoration("Address", Icons.location_on),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              autocorrect: false,
              controller: _registerController.passwordController,
              obscureText: true,
              validator: (value) {
                if (_registerController.passwordController.text.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: getInputDecoration("Password", Icons.password),
              onSaved: (password) {
                _registerController.requestModel.password = password;
              },
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Hero(
            tag: "signup_btn",
            child: ElevatedButton(
              onPressed: _register,
              child: Text(
                "Register!".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextButton(
            child: const Text("Login here"),
            onPressed: () {
              ScreenNavigator.navigateToScreen(
                context,
                const LoginScreen(),
                pushReplacement: true,
              );
            },
          )
        ],
      ),
    );
  }
}
