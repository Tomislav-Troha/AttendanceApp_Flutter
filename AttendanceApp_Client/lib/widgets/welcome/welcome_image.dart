import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'logo_img',
          child: Image.asset(
            "assets/images/mark.png",
            height: 340,
          ),
        ),
      ],
    );
  }
}
