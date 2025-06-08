import 'package:flutter/material.dart';
import 'package:inright/features/auth/presentation/forgot_password_screen.dart';
import 'package:inright/features/auth/presentation/login_screen.dart';
import 'package:inright/features/auth/presentation/register_screen.dart';
import 'package:inright/features/home/presentation/widgets/navbar.dart';
import 'package:inright/features/home/providers/dosesProvider.dart';
import 'package:inright/features/home/providers/inrProvider.dart';
import 'package:inright/features/configurations/presentation/pages/configurations.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/features/configurations/providers/profile_config_provider.dart';
import 'package:inright/features/configurations/providers/notification_config_provider.dart';
import 'package:inright/services/configurations/medication_config.service.dart';
import 'package:inright/features/welcome/presentation/pages/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inright/services/home/doses.service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inright/services/auth/firebaseAuth.service.dart';
import 'package:inright/features/home/providers/user_provider.dart';
import 'package:inright/services/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  // Verificar autenticación inicial
  final authService = FirebaseAuthService();
  final isAuthenticated = await authService.verifyAuthStatus();

  // Crear y precargar UserProvider
  final userProvider = UserProvider();
  if (authService.isAuthenticated) {
    await userProvider.loadUserData(forceRefresh: true);
  }

  // Crear el provider de medicación
  final medicationProvider = MedicationConfigProvider();
  // Cargamos los datos guardados
  await MedicationConfigService().loadMedicationConfig(medicationProvider);
  medicationProvider
    ..generarDosisSegunEsquema(silent: true)
    ..marcarFaltas();

  // Syncronize with FireStore for the latest doses
  if (authService.isAuthenticated) {
    final firestoreDoses = await DosisService().getDosesHistory();
    for (var local in medicationProvider.dosisGeneradas) {
      final fechaStr =
          '${local.fecha.year}-${local.fecha.month.toString().padLeft(2, '0')}-${local.fecha.day.toString().padLeft(2, '0')}';
      final coincidencia = firestoreDoses.firstWhere(
        (f) => f['fecha'] == fechaStr && f['hora'] == local.hora,
        orElse: () => {},
      );
      if (coincidencia.isNotEmpty) {
        local.tomada = true;
        local.estado = coincidencia['estado'] ?? 'ok';
        local.horaToma =
            coincidencia['horaToma'] != null
                ? DateTime.parse(coincidencia['horaToma'])
                : DateTime.now();
      }
    }
  }

  // Initialize notification service and set up medication reminders
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MedicationConfigProvider>.value(
          value: medicationProvider,
        ),
        ChangeNotifierProvider(create: (_) => InrProvider()..fetchInr()),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => ProfileConfigProvider()),
        ChangeNotifierProvider(create: (_) => NotificationConfigProvider()),
        ChangeNotifierProvider(create: (_) => DosisProvider()..fetchDosis()),
      ],
      child: MainApp(isFirstTime: isFirstTime, initialAuth: isAuthenticated),
    ),
  );

  if (isFirstTime) {
    await prefs.setBool('first_time', false);
  }
}

class MainApp extends StatelessWidget {
  final bool isFirstTime;
  final bool initialAuth;
  final FirebaseAuthService _authService = FirebaseAuthService();

  MainApp({super.key, required this.isFirstTime, required this.initialAuth});

  @override
  Widget build(BuildContext context) {
    // Determinar ruta inicial basada en autenticación
    String initialRoute;
    if (isFirstTime) {
      initialRoute = '/welcome';
    } else if (initialAuth) {
      initialRoute = '/home';

      // Programar carga de datos de usuario para después
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.loadUserData(forceRefresh: false);
      });
    } else {
      initialRoute = '/login';
    }

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        // Rutas protegidas
        if (_isProtectedRoute(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => _buildProtectedRoute(context, settings),
            settings: settings,
          );
        }
        return null;
      },
    );
  }

  bool _isProtectedRoute(String? routeName) {
    final publicRoutes = [
      '/welcome',
      '/login',
      '/register',
      '/forgot-password',
    ];
    return routeName != null && !publicRoutes.contains(routeName);
  }

  Widget _buildProtectedRoute(BuildContext context, RouteSettings settings) {
    // Verificar autenticación actual de forma síncrona primero
    if (!_authService.isAuthenticated) {
      // NO llamar a métodos que actualicen el estado durante el build
      return _buildRedirectWidget(context);
    }

    // NO cargar datos de usuario aquí durante la fase de build - esto causa el error
    // En lugar de eso, programarlo para después del build en el widget real

    // Cargar la ruta solicitada sin llamar a loadUserData durante build
    switch (settings.name) {
      case '/home':
        return const Navbar();
      case '/configurations':
        return const Configurations();
      default:
        return const Navbar(); // Default para rutas protegidas no definidas
    }
  }

  Widget _buildRedirectWidget(BuildContext context) {
    // Este enfoque evita llamar a métodos de navegación durante build
    // Solo programamos la navegación para después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
