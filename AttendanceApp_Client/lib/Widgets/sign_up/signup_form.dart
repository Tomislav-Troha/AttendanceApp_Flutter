import 'package:flutter/material.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Components/already_have_an_account_acheck.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/Screens/Signup/signup_controller.dart';

import '../../Models/register_model.dart';
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
                  ScreenNavigator.navigateToScreen(
                      context, const LoginScreen());
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
      _registerController.requestModel.email =
          _registerController.emailController.text;
      _registerController.requestModel.name =
          _registerController.nameController.text;
      _registerController.requestModel.surname =
          _registerController.surnameController.text;
      _registerController.requestModel.addres =
          _registerController.addressController.text;
      _registerController.requestModel.password =
          _registerController.passwordController.text;

      var dataRegisterProvider = await _userProvider.register(
          _registerController.requestModel, context);

      if (!mounted) return;
      _registerSucceeded(dataRegisterProvider);
    } else {
      AppMessage.showErrorMessage(message: "All fields are required");
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration getInputDecoration(String label) {
      return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightBlue)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightBlue)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightBlueAccent)),
        labelText: label,
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
              controller: _registerController.emailController,
              validator: (value) {
                if (_registerController.emailController.text.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (email) {},
              decoration: getInputDecoration("E-mail"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: _registerController.nameController,
              validator: (value) {
                if (_registerController.nameController.text.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onSaved: (email) {},
              decoration: getInputDecoration("First name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: _registerController.surnameController,
              validator: (value) {
                if (_registerController.surnameController.text.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved: (email) {},
              decoration: getInputDecoration("Last name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: _registerController.addressController,
              validator: (value) {
                if (_registerController.addressController.text.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              onSaved: (email) {},
              decoration: getInputDecoration("Address"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _registerController.passwordController,
              obscureText: true,
              validator: (value) {
                if (_registerController.passwordController.text.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: getInputDecoration("Password"),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Hero(
            tag: "signup_btn",
            child: ElevatedButton(
              onPressed: _register,
              child: Text("Register!".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_form",
            child: AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
