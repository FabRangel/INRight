import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/tarjetaIndicador.dart';
import 'package:inright/features/home/presentation/widgets/dosisHistorial.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      body: Stack(
        children: [
          ClipPath(
            clipper: _CurvedClipper(),
            child: Container(height: 350, color: const Color(0xFF9AC6D5)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                  const Center(
                    child: Text(
                      'Dosis diaria',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Center(
                    child: Text(
                      '7.5 mg',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '9:00 pm',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
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

          Positioned.fill(
            top: 320, // debajo del encabezado
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, bottom: 80),
              child: Column(
                children: [
                  // Tarjetas
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TarjetaIndicador(
                            icon: Icons.check_circle_outline,
                            label: 'Cumplimiento',
                            valor: '98%',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TarjetaIndicador(
                            icon: Icons.access_time,
                            label: 'Hora promedio',
                            valor: '09:15',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Historial
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Historial de dosis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16),
                          ItemHistorial(
                            estado: 'ok',
                            dosis: '7.5 mg',
                            hora: '09:00',
                            fecha: '15 Ene',
                          ),
                          ItemHistorial(
                            estado: 'ok',
                            dosis: '7.5 mg',
                            hora: '09:15',
                            fecha: '14 Ene',
                          ),
                          ItemHistorial(
                            estado: 'ok',
                            dosis: '7.5 mg',
                            hora: '09:30',
                            fecha: '13 Ene',
                          ),
                          ItemHistorial(
                            estado: 'tarde',
                            dosis: '7.5 mg',
                            hora: '10:15',
                            fecha: '12 Ene',
                          ),
                          ItemHistorial(
                            estado: 'falta',
                            dosis: '7.5 mg',
                            hora: '--',
                            fecha: '11 Ene',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration:
          seleccionado
              ? BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              )
              : null,
      child: Text(
        letra,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
