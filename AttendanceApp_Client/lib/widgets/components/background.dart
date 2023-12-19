import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background(
      {super.key,
      required this.child,
      this.resizeToAvoidBottomInset,
      this.decoration});

  final Widget child;
  final bool? resizeToAvoidBottomInset;
  final BoxDecoration? decoration;

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
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
