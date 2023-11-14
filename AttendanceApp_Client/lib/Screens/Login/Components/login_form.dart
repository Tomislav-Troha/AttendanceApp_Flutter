import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/Components/already_have_an_account_acheck.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/main_screen.dart';
import 'package:swimming_app_client/Screens/Signup/signup_screen.dart';
import '../../../Managers/token_manager.dart';
import '../../../Widget-Helpers/app_message.dart';
import '../../../Widget-Helpers/screen_navigator.dart';
import '../login_controller.dart';

class LoginForm extends StatefulWidget {
  @override
  createState() => _LoginForm();
  LoginForm({
    Key? key,
  }) : super(key: key);
}


class _LoginForm extends State<LoginForm>{

  late LoginController loginController = LoginController();
  late bool _isLoading = false;
  UserProvider userProvider = UserProvider();

  void login() async {
    var dateProviderLogin = await userProvider.login(loginController.requestModel, context);

      if(dateProviderLogin.success == true){
        //dekodiramo token u userRole iz claimova
        Map<String, dynamic> decodedToken = Jwt.parseJwt(dateProviderLogin.token.toString());
        if (!mounted) return;
        ScreenNavigator.navigateToScreen(context, HomeScreen(decodedToken: decodedToken), pushReplacement: true);

        AppMessage.showSuccessMessage(message: "Login succeeded", duration: 1);
        setState(() {_isLoading = false;});
      }
      else {
        setState(() =>  _isLoading = false);

        List? error = dateProviderLogin.errors;
        for (int i = 0; i < error!.length; i++) {
          AppMessage.showErrorMessage(message: error[i]);
        }
      }
  }

  @override
  initState(){

    _isLoading = false;

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: loginController.emailController,
            validator: (value) {
              if (loginController.emailController.text.isEmpty) {
                return 'Please insert your email';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelStyle:
              MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
                final Color color = states.contains(MaterialState.error)
                    ? Theme.of(context).colorScheme.error
                    : Colors.black;
                return TextStyle(color: color, letterSpacing: 1.3);
              }),
              labelText: "E-mail",
              prefixIcon: const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: loginController.passwordController,
              obscureText: true,
              validator: (value) {
                if (loginController.passwordController.text.isEmpty) {
                  return 'Please insert your password';
                }
                return null;
              },
              // cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                floatingLabelStyle:
                MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
                  final Color color = states.contains(MaterialState.error)
                      ? Theme.of(context).colorScheme.error
                      : Colors.black;
                  return TextStyle(color: color, letterSpacing: 1.3);
                }),
                labelText: "Password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    loginController.requestModel.email = loginController.emailController.text;
                    loginController.requestModel.password = loginController.passwordController.text;
                    TokenManager.clearPrefs();
                    login();
                }
                else {
                  AppMessage.showErrorMessage(message: "All field are required", duration: 1);
                }
              },
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) :
              Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextButton(
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                AppMessage.showSuccessMessage(message: "Please contact your superior for account activation", duration: 2);
              }
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              ScreenNavigator.navigateToScreen(context, const SignUpScreen());
            },
          ),
        ],
      ),
    );
  }
}
