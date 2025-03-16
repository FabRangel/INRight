import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inright/pages/welcome/welcome_screen.dart';
import 'package:inright/features/auth/presentation/login_screen.dart';
import 'package:inright/features/auth/presentation/register_screen.dart';
import 'package:inright/features/auth/presentation/forgot_password_screen.dart';
import 'package:inright/features/home/presentation/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  runApp(MainApp(isFirstTime: isFirstTime));

  if (isFirstTime) {
    await prefs.setBool('first_time', false);
  }
}

class MainApp extends StatelessWidget {
  final bool isFirstTime;

  const MainApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: isFirstTime ? '/welcome' : '/login',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => Home(),
      },
    );
  }
}
