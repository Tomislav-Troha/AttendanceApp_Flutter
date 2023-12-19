import 'package:flutter/material.dart';
import 'package:swimming_app_client/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Register".toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: defaultPadding),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
