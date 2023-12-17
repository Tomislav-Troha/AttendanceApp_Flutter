import 'package:flutter/material.dart';
import 'package:swimming_app_client/Constants.dart';
import 'package:swimming_app_client/Screens/Components/background.dart';
import 'package:swimming_app_client/responsive.dart';

import '../../Widgets/sign_up/sign_up_top_image.dart';
import '../../Widgets/sign_up/signup_form.dart';
import 'mobile_sign_up_screen/mobile_sign_up_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignupScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
