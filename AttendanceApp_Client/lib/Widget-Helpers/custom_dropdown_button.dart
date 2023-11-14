import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final String hint;
  final ValueChanged onChanged;

  CustomDropdownButton({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hint,
  });

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
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 10.0),
            DropdownButton(
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
