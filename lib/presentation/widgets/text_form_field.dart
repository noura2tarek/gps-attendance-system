import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {

  const TextFormFieldWidget({
    required this.labelText,
    required this.controller,
    required this.validator,
    required this.prefixIcon,
    super.key,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
  });
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
        obscureText: obscureText,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
