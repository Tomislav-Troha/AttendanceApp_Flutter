import 'package:flutter/material.dart';

import '../../constants.dart';

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
    required this.context,
    required this.text,
    required this.scale,
  });

  final BuildContext context;
  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(
        text,
        textScaleFactor: scale,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
