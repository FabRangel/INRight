import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/features/home/presentation/widgets/tarjetaIndicador.dart';
import 'package:inright/features/home/presentation/widgets/dosisHistorial.dart';

/// Página de historial con selector de día (L-D).
class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  late String _selectedDay; // ej. 'lunes'

  @override
  void initState() {
    super.initState();
    _selectedDay = _diaActual();
  }

  //─────────────────────── Helpers ────────────────────────
  String _diaActual() {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    return dias[DateTime.now().weekday - 1];
  }

  String _fechaLegible(DateTime f) =>
      '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}';

  String _horaLegible(DateTime? h, String programada) =>
      h == null
          ? programada
          : '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}';

  String _cumplimiento(List<DosisDiaria> d) =>
      d.isEmpty
          ? '0%'
          : '${(d.where((e) => e.tomada).length * 100 / d.length).round()}%';

  String _horaPromedio(List<DosisDiaria> d) {
    final confirmadas = d.where((e) => e.tomada && e.horaToma != null).toList();
    if (confirmadas.isEmpty) return '--:--';
    final totMin = confirmadas.fold<int>(
      0,
      (s, e) => s + e.horaToma!.hour * 60 + e.horaToma!.minute,
    );
    final avg = totMin ~/ confirmadas.length;
    return '${(avg ~/ 60).toString().padLeft(2, '0')}:${(avg % 60).toString().padLeft(2, '0')}';
  }

  //──────────────────────── Build ────────────────────────
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicationConfigProvider>(context);

    // esquema del día seleccionado
    final esquemaSel = provider.esquemas.firstWhere(
      (e) => e.dias.contains(_selectedDay),
      orElse: () => MedicationSchema(dosis: 0, dias: [], hora: '--:--'),
    );

    // historial completo (descendente)
    final historial = [...provider.dosisGeneradas]
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FB),
      body: Stack(
        children: [
          const _FondoCurvo(),
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
                      '${esquemaSel.dosis} mg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${esquemaSel.hora} hrs',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Selector de día L-D
                  //
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((l) {
                            const map = {
                              'L': 'lunes',
                              'M': 'martes',
                              'X': 'miércoles',
                              'J': 'jueves',
                              'V': 'viernes',
                              'S': 'sábado',
                              'D': 'domingo',
                            };
                            final dia = map[l]!;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedDay = dia),
                                child: _DiaTexto(
                                  l,
                                  seleccionado: dia == _selectedDay,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sección scrollable
          Positioned(
            top: 320,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: _HistorialSection(
                historial: historial,
                cumplimiento: _cumplimiento(historial),
                horaProm: _horaPromedio(historial),
                horaLegible: _horaLegible,
                fechaLegible: _fechaLegible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//──────────────────────── Historial section ────────────────────────
class _HistorialSection extends StatelessWidget {
  final List<DosisDiaria> historial;
  final String cumplimiento;
  final String horaProm;
  final String Function(DateTime?, String) horaLegible;
  final String Function(DateTime) fechaLegible;

  const _HistorialSection({
    required this.historial,
    required this.cumplimiento,
    required this.horaProm,
    required this.horaLegible,
    required this.fechaLegible,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, bottom: 80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TarjetaIndicador(
                    icon: Icons.check_circle_outline,
                    label: 'Cumplimiento',
                    valor: cumplimiento,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TarjetaIndicador(
                    icon: Icons.access_time,
                    label: 'Hora promedio',
                    valor: horaProm,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  if (historial.isEmpty)
                    const Text(
                      'Aún no hay registros',
                      style: TextStyle(color: Colors.black45),
                    ),
                  for (final d in historial)
                    ItemHistorial(
                      estado: d.estado.toLowerCase(),
                      dosis: '${d.dosis} mg',
                      hora: horaLegible(d.horaToma, d.hora),
                      fecha: fechaLegible(d.fecha),
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

//──────────────────────── Widgets auxiliares ─────────────────────
class _DiaTexto extends StatelessWidget {
  final String letra;
  final bool seleccionado;
  const _DiaTexto(this.letra, {required this.seleccionado});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration:
          seleccionado
              ? BoxDecoration(
                color: Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(30),
              )
              : null,
      child: Text(
        letra,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FondoCurvo extends StatelessWidget {
  const _FondoCurvo();

  @override
  Widget build(BuildContext context) => ClipPath(
    clipper: _CurvedClipper(),
    child: Container(
      height: 350,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBFE8EE), Color(0xFF62BFE4), Color(0xFF72C1E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
    ),
  );
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final p = Path();
    p.lineTo(0, s.height * .8);
    p.quadraticBezierTo(s.width * .3, s.height, s.width, s.height * .79);
    p.lineTo(s.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
