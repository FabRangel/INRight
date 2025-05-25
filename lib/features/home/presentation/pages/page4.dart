import 'package:flutter/material.dart';
import 'package:inright/features/home/domain/providers/medication_config_provider.dart';
import 'package:inright/features/home/presentation/widgets/tarjetaIndicador.dart';
import 'package:inright/features/home/presentation/widgets/dosisHistorial.dart';
import 'package:provider/provider.dart';

String obtenerDiaActual() {
  final dias = [
    "lunes",
    "martes",
    "miércoles",
    "jueves",
    "viernes",
    "sábado",
    "domingo",
  ];
  return dias[DateTime.now().weekday - 1];
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicationConfigProvider>(context);
    final esquemaActual =
        provider.esquemas.isNotEmpty ? provider.esquemas[0] : null;
    final String diaActual = obtenerDiaActual();
    final historial = provider.historial;
    final esquemaDelDia = provider.esquemas.firstWhere(
      (e) => e.dias.contains(diaActual),
      orElse: () => MedicationSchema(dosis: 0.0, dias: [], hora: "--:--"),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      body: Stack(
        children: [
          ClipPath(
            clipper: _CurvedClipper(),
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 191, 232, 238),
                    Color.fromARGB(255, 98, 191, 228),
                    Color.fromARGB(255, 114, 193, 224),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registro de dosis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                  Center(
                    child: Text(
                      '${esquemaDelDia?.dosis ?? 0.0} mg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${esquemaDelDia?.hora ?? '--:--'} hrs',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        ["L", "M", "X", "J", "V", "S", "D"].map((letra) {
                          final diasMap = {
                            "L": "lunes",
                            "M": "martes",
                            "X": "miércoles",
                            "J": "jueves",
                            "V": "viernes",
                            "S": "sábado",
                            "D": "domingo",
                          };
                          final diaCompleto = diasMap[letra]!;
                          final seleccionado = diaCompleto == diaActual;

                          return _DiaTexto(letra, seleccionado: seleccionado);
                        }).toList(),
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
                        children: [
                          const Text(
                            'Historial de dosis',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (final item in historial)
                            ItemHistorial(
                              estado: item.estado,
                              dosis: item.dosis,
                              hora: item.hora,
                              fecha: item.fecha,
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
