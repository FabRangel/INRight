import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/configurations.dart';
import 'package:inright/features/home/presentation/pages/page1.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:inright/features/home/presentation/pages/page3.dart';
import 'package:inright/features/home/presentation/pages/page4.dart';
import 'package:inright/features/home/presentation/pages/page5.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:inright/pages/welcome/welcome_screen.dart';
import 'package:inright/features/auth/presentation/login_screen.dart';
import 'package:inright/features/auth/presentation/register_screen.dart';
import 'package:inright/features/auth/presentation/forgot_password_screen.dart';
import 'package:inright/features/home/presentation/widgets/navbar.dart';
import 'package:inright/features/home/domain/providers/medication_config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MedicationConfigProvider>(
          create: (_) {
            final provider = MedicationConfigProvider();
            provider
              ..generarDosisSegunEsquema(silent: true)
              ..marcarFaltas();
            return provider;
          },
        ),
      ],
      child: MainApp(isFirstTime: isFirstTime),
    ),
  );

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
        '/home': (context) => Navbar(),
        '/configurations': (context) => Configurations(),
      },
    );
  }
}
