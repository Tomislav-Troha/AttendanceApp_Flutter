import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../../widgets/components/background.dart';
import '../../widgets/welcome/login_signup_btn.dart';
import '../../widgets/welcome/welcome_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
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
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WelcomeImage(),
            SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: LoginAndSignupBtn(),
            ),
          ],
        ),
      ),
    );
  }
}
