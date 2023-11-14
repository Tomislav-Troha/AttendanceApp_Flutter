import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swimming_app_client/Constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/images/logo.svg", width: 200, height: 200),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}