import 'package:flutter/material.dart';
import 'package:swimming_app_client/constants.dart';
import 'package:swimming_app_client/responsive.dart';

import '../../Widgets/sign_up/sign_up_top_image.dart';
import '../../Widgets/sign_up/signup_form.dart';
import '../../widgets/components/background.dart';
import 'mobile_sign_up_screen/mobile_sign_up_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(),
          desktop: Row(
            children: [
              Expanded(
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
                    SizedBox(height: defaultPadding / 2),
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
