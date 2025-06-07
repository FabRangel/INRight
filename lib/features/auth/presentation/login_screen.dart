import 'package:flutter/material.dart';
import 'package:inright/features/home/providers/dosesProvider.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/home/providers/user_provider.dart';
import 'package:inright/services/auth/firebaseAuth.service.dart';
import 'package:inright/features/configurations/providers/profile_config_provider.dart';
import 'package:inright/features/configurations/providers/notification_config_provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
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
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool _isProcessingLogout = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoggedOut();
    });
  }

  Future<void> _ensureLoggedOut() async {
    if (_isProcessingLogout) return;
    _isProcessingLogout = true;

    try {
      if (!_firebaseAuthService.isAuthenticated) {
        _isProcessingLogout = false;
        return;
      }

      await _firebaseAuthService.signOut();

      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.silentSignOut();
    } catch (e) {
      print("Error al cerrar sesión en LoginScreen: $e");
    } finally {
      _isProcessingLogout = false;
    }
  }

  Future<void> _loginUser() async {
    try {
      await _firebaseAuthService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;

      // Actualizar datos de todos los providers tras inicio de sesión exitoso
      await _refreshAllProviders(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Inicio de sesión exitoso")));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar sesión: ${e.toString()}")),
      );
    }
  }

  Future<void> _refreshAllProviders(BuildContext context) async {
    // // Refrescar datos de usuario
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // await userProvider.refreshUserData();

    // // Los demás providers tienen listeners para authStateChanges y se refrescarán automáticamente,
    // // pero podemos forzar una actualización si es necesario
    // try {
    //   final profileProvider = Provider.of<ProfileConfigProvider>(
    //     context,
    //     listen: false,
    //   );
    //   profileProvider.forceRefresh();

    //   final notificationProvider = Provider.of<NotificationConfigProvider>(
    //     context,
    //     listen: false,
    //   );

    //   if (!mounted) return;
    //   notificationProvider.forceRefresh();

    //   final medicationProvider = Provider.of<MedicationConfigProvider>(
    //     context,
    //     listen: false,
    //   );
    //   medicationProvider.forceRefresh();
    // } catch (e) {
    //   print("Error refreshing providers: $e");
    // }
    await Provider.of<UserProvider>(context, listen: false).loadUserData(forceRefresh: true);
    await Provider.of<MedicationConfigProvider>(
      context,
      listen: false,
    ).forceRefresh();
    Provider.of<NotificationConfigProvider>(
      context,
      listen: false,
    ).forceRefresh();
    await Provider.of<ProfileConfigProvider>(
      context,
      listen: false,
    ).forceRefresh();
    await Provider.of<DosisProvider>(context, listen: false).fetchDosis();
  }

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
                  if (value == null || value.isEmpty)
                    return 'El correo es requerido';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                  ).hasMatch(value))
                    return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Contraseña",
                isPassword: true,
                controller: _passwordController,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'La contraseña es requerida'
                            : null,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text("Recuperar Contraseña"),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: "Iniciar Sesión",
                buttonColor: const Color(0xFF6CAFB7),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginUser();
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: "Iniciar Sesión con Google",
                isGoogle: true,
                onPressed: () async {
                  final credential =
                      await _firebaseAuthService.signInWithGoogle();

                  if (credential != null) {
                    // ¡Éxito! Puedes redirigir a la pantalla principal
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al iniciar sesión con Google'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Nuevo usuario?"),
                  TextButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/register',
                        ),
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
