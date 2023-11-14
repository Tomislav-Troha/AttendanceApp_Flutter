import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   child: Image.asset(
            //     bottomImage,
            //     width: 120,
            //   ),
            // ),
            // Positioned(
            //   bottom: -50,
            //   right: 0,
            //   child: Image.asset(bottomImage, width: 500, height: 400),
            // ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}