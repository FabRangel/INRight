import 'package:flutter/material.dart';

class RegisterItem extends StatelessWidget {
  final String value;
  final String date;
  final String time;
  final String trend;

  const RegisterItem({
    super.key,
    required this.value,
    required this.date,
    required this.time,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final isTomorrow = value == "Mañana";
    final isNight = value == "Noche";

    final bgColor =
        isTomorrow ? const Color(0xFFFFEBEB) : const Color(0xFFEAFBF0);

    final iconBg = isNight ? const Color(0xFFFFE1E1) : const Color(0xFFDFF7E8);

    final icon =
        trend == 'up'
            ? Icons.arrow_upward
            : trend == 'down'
            ? Icons.arrow_downward
            : Icons.remove;

    final valueColor = isTomorrow ? Colors.yellow : Colors.green;

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
                value,
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
