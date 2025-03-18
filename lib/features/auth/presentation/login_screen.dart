import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Hola De Nuevo",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Completa tus datos o continúa con redes sociales",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Correo Electrónico",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El correo es requerido';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Contraseña",
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es requerida';
                  }
                  return null;
                },
              ),
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
              CustomButton(
                label: "Iniciar Sesión",
                buttonColor: const Color(0xFF6CAFB7),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lógica de inicio de sesión
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: "Iniciar Sesión con Google",
                isGoogle: true,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Nuevo usuario?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text("Crea una cuenta"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
