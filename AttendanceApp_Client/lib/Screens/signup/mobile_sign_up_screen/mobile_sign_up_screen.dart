import 'package:flutter/material.dart';

import '../../../Widgets/sign_up/sign_up_top_image.dart';
import '../../../Widgets/sign_up/signup_form.dart';

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            const Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
