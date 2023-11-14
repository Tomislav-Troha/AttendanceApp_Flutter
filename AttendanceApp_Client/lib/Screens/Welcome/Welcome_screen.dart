import 'package:flutter/material.dart';
import 'package:swimming_app_client/Screens/Components/background.dart';
import 'package:swimming_app_client/Screens/Welcome/Components/login_signup_btn.dart';
import 'package:swimming_app_client/Screens/Welcome/Components/welcome_image.dart';
import '../../responsive.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: WelcomeImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: LoginAndSignupBtn(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(),
        SizedBox(height: 32),
        // Text(
        //   'Welcome to the Attendance App',
        //   style: TextStyle(
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: LoginAndSignupBtn(),
        ),
      ],
    );
  }
}
