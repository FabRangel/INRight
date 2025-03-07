import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool isGoogle;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.label, required this.onPressed, this.isGoogle = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isGoogle ? Colors.white : Colors.blue,
        foregroundColor: isGoogle ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isGoogle ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isGoogle) Icon(Icons.g_translate, color: Colors.black),
          if (isGoogle) const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}