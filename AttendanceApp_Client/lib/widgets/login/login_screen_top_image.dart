import 'package:flutter/material.dart';

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
              child: Hero(
                tag: 'logo_img',
                child: Image.asset(
                  "assets/images/attendance_logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
