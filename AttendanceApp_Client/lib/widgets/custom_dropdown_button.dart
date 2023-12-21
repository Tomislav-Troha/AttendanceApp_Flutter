import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hint,
    this.textColor,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final String hint;
  final ValueChanged onChanged;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10.0),
          DropdownButton(
            style: TextStyle(color: textColor),
            hint: Text(hint),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
