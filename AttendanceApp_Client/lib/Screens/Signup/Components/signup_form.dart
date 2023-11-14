import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Components/already_have_an_account_acheck.dart';
import 'package:swimming_app_client/Screens/Login/Login.dart';
import 'package:swimming_app_client/Screens/Signup/signup_controller.dart';
import 'package:swimming_app_client/Widget-Helpers/app_message.dart';
import 'package:swimming_app_client/Widget-Helpers/custom_dialog.dart';
import 'package:swimming_app_client/Widget-Helpers/custom_text_button.dart';
import 'package:swimming_app_client/Widget-Helpers/screen_navigator.dart';

class SignUpForm extends StatelessWidget {

  late SignupController registerController = SignupController();

   SignUpForm({
    Key? key,
  }) : super(key: key);


  final _formKey = GlobalKey<FormState>();
  UserProvider userProvider = UserProvider();

  void register(BuildContext context) async {
    var dataRegisterProvider = await userProvider.register(registerController.requestModel, context);

    // Check whether the context is still valid (i.e., the widget is still part of the tree)
    if (Navigator.canPop(context)) {
      if (dataRegisterProvider.success == true) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: "Registracija uspješna",
              message: "Da bi ste aktivirali račun obratite se nadređenom",
              children: [
                CustomTextButton(
                  text: "Ok",
                  textSize: 20,
                  onPressed: () {
                    ScreenNavigator.navigateToScreen(context, const LoginScreen());
                  },
                ),
              ],
            );
          },
        );
      } else {
        List? error = dataRegisterProvider.errors;
        for (int i = 0; i < error!.length; i++) {
          AppMessage.showErrorMessage(message: error[i]);
        }
      }
    }
  }



  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: registerController.emailController,
          validator: (value) {
            if (registerController.emailController.text.isEmpty) {
              return 'Please insert your email';
            }
            return null;
          },
          onSaved: (email) {},
          decoration: InputDecoration(
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
            labelText: "E-mail",
          ),
        ),
      ),
    Padding(padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
    child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: registerController.nameController,
            validator: (value) {
              if (registerController.nameController.text.isEmpty) {
                return 'Please insert your name';
              }
              return null;
            },
            onSaved: (email) {},
            decoration: InputDecoration(
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
              labelText: "First name",
            ),
          ),
    ),
    Padding(padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
    child:TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: registerController.surnameController,
            validator: (value) {
              if (registerController.surnameController.text.isEmpty) {
                return 'Please insert your first name';
              }
              return null;
            },
            onSaved: (email) {},
            decoration: InputDecoration(
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
              labelText: "Last name",
            ),
          ),
    ),
    Padding(padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
    child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: registerController.addressController,
            validator: (value) {
              if (registerController.addressController.text.isEmpty) {
                return 'Please insert your address';
              }
              return null;
            },
            onSaved: (email) {},
            decoration:  InputDecoration(
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
              labelText: "Address",
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: registerController.passwordController,
              obscureText: true,
              validator: (value) {
                if (registerController.passwordController.text.isEmpty) {
                  return 'Please insert your password';
                }
                return null;
              },
              decoration:  InputDecoration(
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
                labelText: "Password",
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Hero(tag: "signup_btn",
            child: ElevatedButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()){

                registerController.requestModel.email = registerController.emailController.text;
                registerController.requestModel.name = registerController.nameController.text;
                registerController.requestModel.surname = registerController.surnameController.text;
                registerController.requestModel.addres = registerController.addressController.text;
                registerController.requestModel.password = registerController.passwordController.text;

                register(context);

              }
              else {
                AppMessage.showErrorMessage(message: "All fields are required");
              }
            },
            child: Text("Register!".toUpperCase()),
          ),),
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