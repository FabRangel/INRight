import 'package:flutter/material.dart';
import './widgets/custom_text_field.dart';
import './widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hola De Nuevo",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Completa tus datos o continúa con redes sociales",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            CustomTextField(label: "Correo Electrónico"),
            const SizedBox(height: 10),
            CustomTextField(label: "Contraseña", isPassword: true),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text("Recuperar Contraseña"),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(label: "Iniciar Sesión", onPressed: () {}),
            const SizedBox(height: 10),
            CustomButton(label: "Iniciar Sesión con Google", isGoogle: true, onPressed: () {}),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Nuevo usuario?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("Crea una cuenta"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}