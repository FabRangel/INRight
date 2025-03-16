import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inright/features/home/presentation/home.dart';
import 'package:inright/pages/welcome/welcome_screen.dart';

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
      initialRoute: isFirstTime ? '/welcome' : '/home',
      routes: {
        '/home': (context) => Home(),
        '/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
