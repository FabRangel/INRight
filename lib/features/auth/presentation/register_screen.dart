import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inright/features/auth/presentation/email_verification_modal.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';
import 'package:inright/services/auth/firebaseAuth.service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = FirebaseAuthService();

  void _showTopSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType type,
    Color color,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
        color: color,
        inMaterialBanner: true,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _registerUser() async {
    try {
      await _authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado correctamente")),
      );
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      // Show email verification modal
      _showTopSnackBar(
        context,
        "Usuario Registrado",
        "Por favor, verifica tu correo electrónico para activar tu cuenta.",
        ContentType.success,
        Colors.green,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error al registrar';
      if (e.code == 'email-already-in-use') {
        message = 'El correo ya está en uso';
      } else if (e.code == 'weak-password') {
        message = 'Contraseña débil';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Registrar Cuenta",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Completa tus datos o continúa con redes sociales",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "Tu Nombre",
                        controller: _nameController,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'El nombre es requerido'
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Correo Electrónico",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'El correo es requerido';
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
                          if (value == null || value.isEmpty)
                            return 'La contraseña es requerida';
                          if (value.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Confirmar Contraseña",
                        isPassword: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Confirma tu contraseña';
                          if (value != _passwordController.text)
                            return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        label: "Registrarse",
                        buttonColor: const Color(0xFF6CAFB7),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      // CustomButton(
                      //   label: "Registrarse con Google",
                      //   isGoogle: true,
                      //   onPressed: () {},
                      // ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes cuenta?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text("Iniciar Sesión"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
