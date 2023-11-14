import 'package:flutter/material.dart';

import '../Constants.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validate;
  final bool readOnly;
  final IconButton? iconButton;
  final bool obscureText;

  CustomTextFormField({
    Key? key,
    this.controller,
    required this.textInputAction,
    required this.keyboardType,
    required this.labelText,
    required this.prefixIcon,
    this.onTap,
    this.validate,
    this.readOnly = false,
    this.iconButton,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding),
    child: TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        suffixIcon: iconButton,
        floatingLabelStyle: const TextStyle(fontSize: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.lightBlue),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.lightBlue)),
        alignLabelWithHint: true,
        label: Center(
          child: Text(labelText),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(prefixIcon),
        ),
      ),
      readOnly: readOnly,
    ));
  }
}
