import 'dart:ui';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentPage = -1; // Inicia en -1 para mostrar el logo primero
  int _nextPageToShow = -1; // Almacena la próxima página a mostrar
  final List<Map<String, String>> _pages = [
    {
      "title": "BIENVENIDO A",
      "subtitle": "",
      "image": "assets/images/Logo.png",
    },
    {
      "title": "Una app para ayudarte",
      "subtitle": "Inteligente, precisos y facil de usar.",
      "image": "assets/images/Logo.png",
    },
    {
      "title": "Tú Tienes El Control",
      "subtitle": "Controla tu IHR, vivo mejor",
      "image": "assets/images/Logo.png", // Misma imagen que la pantalla 2
    },
  ];

  // Agregar variables para controlar temporizadores o suscripciones
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duración de la animación
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Mostrar el logo durante 5 segundos antes de avanzar a la primera pantalla
    Future.delayed(Duration(seconds: 5), () {
      _safeSetState(() {
        _currentPage = 0; // Cambiar a la primera pantalla
      });
      _controller.forward(); // Iniciar la animación
    });
  }

  @override
  void dispose() {
    // Marcar como disposed para evitar actualizaciones posteriores
    _disposed = true;

    _controller.dispose();
    super.dispose();
  }

  // Método seguro para actualizar el estado
  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _nextPageToShow = _currentPage + 1; // Preparar la próxima página
      _controller.reverse().then((_) {
        // Esperar a que la animación termine antes de cambiar la página
        _safeSetState(() {
          _currentPage = _nextPageToShow;
        });
        _controller.forward(); // Iniciar la animación de la nueva página
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Método para obtener el gradiente según la página actual
  BoxDecoration _getBackgroundDecoration(int currentPage) {
    switch (currentPage) {
      case 0: // Pantalla "BIENVENIDO A"
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF62AFC6), Color(0xFFABD2DD)],
            stops: [0.0, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 50,
              offset: Offset(0, 4),
            ),
          ],
        );
      case 1: // Pantalla "Una app para ayudarte"
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF62AFC6), Color(0xFFABD2DD)],
            stops: [0.6562, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 50,
              offset: Offset(0, 4),
            ),
          ],
        );
      case 2: // Pantalla "Tú Tienes El Control"
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFABD2DD), Color(0xFF62AFC6)],
            stops: [0.1593, 0.4196],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 50,
              offset: Offset(0, 4),
            ),
          ],
        );
      default:
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF62AFC6), Color(0xFFABD2DD)],
            stops: [0.0, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 50,
              offset: Offset(0, 4),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _getBackgroundDecoration(
          _currentPage,
        ), // Aplicamos el gradiente según la página
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Stack(
            children: [
              // Pantalla inicial del logo
              if (_currentPage == -1)
                Center(
                  child: Image.asset(
                    'assets/images/Logo.png', // Ruta corregida
                    width: 343,
                    height: 343,
                  ),
                ),

              // Contenido centrado (imagen, texto y barras de progreso)
              if (_currentPage != -1)
                Center(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentPage == 0)
                          Column(
                            children: [
                              Text(
                                _pages[_currentPage]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Image.asset(
                                _pages[_currentPage]["image"]!, // Imagen ficticia
                                width: 200,
                                height: 200,
                              ),
                            ],
                          ),
                        if (_currentPage == 1 || _currentPage == 2)
                          Column(
                            children: [
                              Image.asset(
                                _pages[_currentPage]["image"]!, // Imagen ficticia
                                width: 200,
                                height: 200,
                              ),
                              SizedBox(height: 20),
                              Text(
                                _pages[_currentPage]["title"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 34,
                                  height: 44.2 / 34,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _pages[_currentPage]["subtitle"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 24 / 16,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 40,
                        ), // Espacio entre el contenido y las barras
                        // Barras de progreso
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => Container(
                              width:
                                  _currentPage == index
                                      ? 30
                                      : 15, // Barras más largas
                              height: 5,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color:
                                    _currentPage == index
                                        ? Colors.white
                                        : Colors.yellow,
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Botón en la parte inferior (solo si no es la pantalla del logo)
              if (_currentPage != -1)
                Positioned(
                  bottom: 110, // Distancia desde la parte inferior
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FadeTransition(
                      opacity: _animation,
                      child:
                          _currentPage == 0
                              ? ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(335, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Iniciar',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                              : ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(335, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Siguiente', // Siempre dice "Siguiente"
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
