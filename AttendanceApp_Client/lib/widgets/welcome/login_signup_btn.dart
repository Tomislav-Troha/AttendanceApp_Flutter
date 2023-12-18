import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Login/login_screen.dart';
import 'package:swimming_app_client/Widgets/screen_navigator.dart';

import '../../Screens/Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              ScreenNavigator.navigateToScreen(context, const LoginScreen());
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Hero(
          tag: "signup_btn",
          child: ElevatedButton(
            onPressed: () {
              ScreenNavigator.navigateToScreen(context, const SignUpScreen());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColorLight,
                elevation: 0),
            child: Text(
              "Register".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ],
    );
  }
}
