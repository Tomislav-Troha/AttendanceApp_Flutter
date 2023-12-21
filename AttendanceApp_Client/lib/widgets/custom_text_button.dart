import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.textSize,
      this.color});

  final String text;
  final VoidCallback onPressed;
  final double textSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          color: color,
        ),
      ),
    );
  }
}
