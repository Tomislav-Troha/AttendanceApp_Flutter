import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Hero(
          tag: 'logo_img',
          child: Image.asset(
            "assets/images/attendance_logo.png",
            width: 200,
            height: 200,
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 40),
      ],
    );
  }
}
