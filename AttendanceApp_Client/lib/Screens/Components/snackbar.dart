import 'package:flutter/material.dart';


class SnackBarMessage extends StatelessWidget {

  const SnackBarMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SnackBar Demo'),
        ),
        body: const SnackBarMessage(),
      ),
    );
  }
}

