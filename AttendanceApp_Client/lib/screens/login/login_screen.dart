import 'package:flutter/material.dart';
import 'package:swimming_app_client/Widgets/login/login_form.dart';
import 'package:swimming_app_client/responsive.dart';

import '../../Widgets/login/login_screen_top_image.dart';
import '../../widgets/components/background.dart';
import 'mobile_login_screen/mobile_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(),
          desktop: Row(
            children: [
              Expanded(
                child: LoginScreenTopImage(),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
