import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:swimming_app_client/Provider/user_provider.dart';
import 'package:swimming_app_client/Screens/PageStorageHome/main_screen.dart';
import 'package:swimming_app_client/Screens/Signup/signup_screen.dart';
import 'package:swimming_app_client/constants.dart';

import '../../Managers/token_manager.dart';
import '../../controllers/login/login_controller.dart';
import '../app_message.dart';
import '../screen_navigator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  final LoginController _loginController = LoginController();
  final UserProvider _userProvider = UserProvider();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _loginController.requestModel.email =
          _loginController.emailController.text;
      _loginController.requestModel.password =
          _loginController.passwordController.text;
      TokenManager.clearPrefs();

      var dateProviderLogin =
          await _userProvider.login(_loginController.requestModel, context);

      if (dateProviderLogin.success == true) {
        //dekodiramo token u userRole iz claimova
        Map<String, dynamic> decodedToken =
            Jwt.parseJwt(dateProviderLogin.token.toString());

        if (!mounted) return;
        ScreenNavigator.navigateToScreen(
            context, HomeScreen(decodedToken: decodedToken),
            pushReplacement: true);

        AppMessage.showSuccessMessage(message: "Login succeeded", duration: 1);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);

        List? error = dateProviderLogin.errors;
        if (error != null && error.isNotEmpty) {
          String concatenatedErrors = error.join('\n');
          AppMessage.showErrorMessage(message: concatenatedErrors);
        } else {
          AppMessage.showErrorMessage(message: "An unknown error occurred.");
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _loginController.emailController,
            validator: (value) {
              if (_loginController.emailController.text.isEmpty) {
                return 'Please insert your email';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                (Set<MaterialState> states) {
                  final Color color = states.contains(MaterialState.error)
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onPrimaryContainer;
                  return TextStyle(color: color, letterSpacing: 1.3);
                },
              ),
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
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
              controller: _loginController.passwordController,
              obscureText: true,
              validator: (value) {
                if (_loginController.passwordController.text.isEmpty) {
                  return 'Please insert your password';
                }
                return null;
              },
              // cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                  (Set<MaterialState> states) {
                    final Color color = states.contains(MaterialState.error)
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onPrimaryContainer;
                    return TextStyle(color: color, letterSpacing: 1.3);
                  },
                ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: !_isLoading ? _login : null,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text("Login".toUpperCase()),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextButton(
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                AppMessage.showSuccessMessage(
                    message:
                        "Please contact your superior for account activation",
                    duration: 2);
              }),
          const SizedBox(height: defaultPadding),
          TextButton(
            child: const Text(
              "New user?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              ScreenNavigator.navigateToScreen(
                context,
                const SignUpScreen(),
                pushReplacement: true,
              );
            },
          )
        ],
      ),
    );
  }
}
