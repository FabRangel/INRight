import 'package:flutter/material.dart';

class BuildEstabilidadCard extends StatelessWidget {
  final double estabilidad; // 0.0 a 1.0

  const BuildEstabilidadCard({Key? key, required this.estabilidad})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fueraDeRango = 1.0 - estabilidad;
    final porcentajeEstabilidad = (estabilidad * 100).toStringAsFixed(0);
    final porcentajeFuera = (fueraDeRango * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Estabilidad',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Anillo de progreso
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: estabilidad,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    color:
                        estabilidad >= 0.6
                            ? Colors.green
                            : (estabilidad >= 0.3 ? Colors.orange : Colors.red),
                  ),
                ),
                Text(
                  '$porcentajeEstabilidad%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('En rango', style: TextStyle(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    '$porcentajeEstabilidad%',
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Fuera de rango', style: TextStyle(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    '$porcentajeFuera%',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
