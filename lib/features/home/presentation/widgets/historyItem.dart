import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final double value;
  final String date;
  final String time;
  final String trend; // 'up', 'down', 'neutral'

  const HistoryItem({
    super.key,
    required this.value,
    required this.date,
    required this.time,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final isHigh = value >= 3.0;
    final isLow = value < 2.6;
    final isNeutral = !isHigh && !isLow;

    final bgColor = isHigh
        ? const Color(0xFFFFEBEB)
        : const Color(0xFFEAFBF0); // rojo claro o verde muy claro

    final iconBg = isHigh
        ? const Color(0xFFFFE1E1)
        : const Color(0xFFDFF7E8); // ícono fondo

    final icon = trend == 'up'
        ? Icons.arrow_upward
        : trend == 'down'
            ? Icons.arrow_downward
            : Icons.remove;

    final iconColor = Colors.black;

    final valueColor = isHigh ? Colors.red : Colors.green;

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
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Hora
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
        
      ),
      
    );
    
  }

}
