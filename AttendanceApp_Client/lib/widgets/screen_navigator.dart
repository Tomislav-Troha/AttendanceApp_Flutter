import 'package:flutter/material.dart';

class ScreenNavigator {

  static void navigateToScreen(BuildContext context, Widget screen, {bool pushReplacement = false}) {
    if(pushReplacement) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => screen));
    } else {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => screen));
    }
  }
}