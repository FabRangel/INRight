import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool isGoogle;
  final VoidCallback onPressed;
  final Color? buttonColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isGoogle = false,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isGoogle ? Colors.white : (buttonColor ?? Colors.blue),
        foregroundColor: isGoogle ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side:
              isGoogle ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isGoogle) const Icon(FontAwesomeIcons.google),
          if (isGoogle) const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
