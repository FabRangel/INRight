import 'package:flutter/material.dart';

class EmailVerificationModal extends StatelessWidget {
  const EmailVerificationModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF6CAFB7),
            child: Icon(Icons.email, size: 30, color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "Revisa tu Correo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Hemos enviado el código de recuperación de contraseña a su correo electrónico.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cerrar",
            style: TextStyle(color: Color(0xFF6CAFB7), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}