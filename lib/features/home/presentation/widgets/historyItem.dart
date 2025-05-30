import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final double value;
  final String date;
  final String time;
  final String trend;
  final bool isInRange; // Nuevo parámetro

  const HistoryItem({
    super.key,
    required this.value,
    required this.date,
    required this.time,
    required this.trend,
    this.isInRange = true, // Valor predeterminado
  });

  @override
  Widget build(BuildContext context) {
    // Usar el parámetro isInRange para determinar colores
    final bgColor =
        isInRange ? const Color(0xFFEAFBF0) : const Color(0xFFFFEBEB);
    final iconBg =
        isInRange ? const Color(0xFFDFF7E8) : const Color(0xFFFFE1E1);
    final valueColor = isInRange ? Colors.green : Colors.red;

    final icon =
        trend == 'up'
            ? Icons.arrow_upward
            : trend == 'down'
            ? Icons.arrow_downward
            : Icons.remove;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
