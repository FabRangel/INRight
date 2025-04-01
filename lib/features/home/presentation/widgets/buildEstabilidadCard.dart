import 'package:flutter/material.dart';

class buildEstabilidadCard extends StatelessWidget {
  const buildEstabilidadCard({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Simulación de anillo
          SizedBox(
            height: 120, //
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    color: Colors.green,
                  ),
                ),
                const Text(
                  '75%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                children: [
                  Text('En rango', style: TextStyle(fontSize: 11)),
                  SizedBox(height: 4),
                  Text(
                    '75%',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Fuera de rango', style: TextStyle(fontSize: 11)),
                  SizedBox(height: 4),
                  Text(
                    '25%',
                    style: TextStyle(fontSize: 12, color: Colors.red),
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
