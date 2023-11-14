import 'dart:ui';
import 'package:flutter/material.dart';

class SensitiveInfoToggle extends StatefulWidget {
  final String sensitiveInfo;

  const SensitiveInfoToggle({required this.sensitiveInfo});

  @override
  _SensitiveInfoToggleState createState() => _SensitiveInfoToggleState();
}

class _SensitiveInfoToggleState extends State<SensitiveInfoToggle> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _isHidden
              ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: const Text(
                    '(hidden)', style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              : Text(
            widget.sensitiveInfo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isHidden = !_isHidden;
            });
          },
        ),
      ],
    );
  }
}
