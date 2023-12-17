import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            width: 250,
            height: 250,
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 40),
      ],
    );
  }
}
