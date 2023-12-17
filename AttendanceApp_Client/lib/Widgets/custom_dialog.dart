import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> children;

  CustomDialog({
    required this.title,
    required this.message,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              title != ""
                  ? Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Container(),
              const SizedBox(height: 10.0),
              message != ""
                  ? Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              )
                  : Container(),
              const SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
