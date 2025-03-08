import 'package:flutter/material.dart';

class CheckInOutButton extends StatelessWidget {
  const CheckInOutButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.borderRadius = 5.0,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
