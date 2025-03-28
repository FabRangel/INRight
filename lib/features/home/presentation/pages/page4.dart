import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: _CurvedClipper(),
                child: Container(
                  height: 350,
                  color: const Color(0xFF9AC6D5), // azul suave
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botón de regresar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                          Icon(Icons.add, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Registro de dosis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: const Text(
                          'Dosis diaria',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Center(
                        child: const Text(
                          '7.5 mg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: const Text(
                          '9:00 pm',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Días de la semana
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _DiaTexto('L'),
                          _DiaTexto('M'),
                          _DiaTexto('X'),
                          _DiaTexto('J', seleccionado: true),
                          _DiaTexto('V'),
                          _DiaTexto('S'),
                          _DiaTexto('D'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiaTexto extends StatelessWidget {
  final String letra;
  final bool seleccionado;
  const _DiaTexto(this.letra, {this.seleccionado = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      letra,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: seleccionado ? Colors.white : Colors.white70,
        decoration:
            seleccionado ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(3, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height,
      size.width,
      size.height * 0.79,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
