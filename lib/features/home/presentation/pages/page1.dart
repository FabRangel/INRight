import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/tendenciaData.dart';
import 'package:inright/features/home/presentation/widgets/legendItem.dart';
import 'package:inright/features/home/presentation/widgets/buildEstabilidadCard.dart';
import 'package:inright/features/home/presentation/widgets/buildTendenciaCard.dart';
import 'package:inright/features/home/presentation/widgets/buildHistorialCard.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String modoSeleccionado = 'Semanal'; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🟦 Header fijo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB4D8E6), Color(0xFF8AC0CE)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Análisis\nINR',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildModeButton('Diario'),
                        const SizedBox(width: 4),
                        _buildModeButton('Semanal'),
                        const SizedBox(width: 4),
                        _buildModeButton('Mensual'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Promedio',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const Text(
                        '2.8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          LegendItem(color: Colors.green, label: 'Normal'),
                          SizedBox(width: 16),
                          LegendItem(
                            color: Colors.red,
                            label: 'Fuera de\nrango',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _buildBars(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔄 Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 100),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildEstabilidadCard()),
                      const SizedBox(width: 16),
                      Expanded(child: buildTendenciaCard()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  buildHistorialCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label) {
    final bool isSelected = label == modoSeleccionado;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          modoSeleccionado = label;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.white24,
        foregroundColor: isSelected ? Colors.black : Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}

List<Widget> _buildBars() {
  final data = [
    {'date': '27\nfeb', 'value': 2.7, 'normal': true},
    {'date': '26\nfeb', 'value': 3.5, 'normal': false},
    {'date': '25\nfeb', 'value': 2.6, 'normal': true},
    {'date': '24\nfeb', 'value': 2.7, 'normal': true},
    {'date': '23\nfeb', 'value': 2.5, 'normal': true},
    {'date': '22\nfeb', 'value': 2.9, 'normal': true},
    {'date': '21\nfeb', 'value': 2.6, 'normal': true},
  ];

  return data.map((entry) {
    final barHeight = (entry['value'] as double) * 15;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: barHeight,
          decoration: BoxDecoration(
            color:
                (entry['normal']! as bool)
                    ? const Color.fromARGB(255, 63, 179, 104)
                    : Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry['date']! as String,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }).toList();
}
