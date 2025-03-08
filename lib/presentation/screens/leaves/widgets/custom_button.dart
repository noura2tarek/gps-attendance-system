import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    required this.text, required this.onPressed, Key? key,
    this.backgroundColor = Colors.blueAccent,
    this.opacity = 0.8,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor.withValues(alpha: opacity),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
