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
    final isCheck = trend == "check";
    final isWait = trend == "wait";

    final bgColor =
        isCheck
            ? const Color(0xFFEAFBF0)
            : const Color.fromARGB(255, 254, 254, 224);

    final iconBg = isWait ? Colors.yellow.shade100 : const Color(0xFFDFF7E8);

    final textBg = isWait ? Colors.yellow.shade700 : Colors.green;

    final icon =
        trend == 'check'
            ? Icons.check_outlined
            : trend == 'wait'
            ? Icons.access_time
            : Icons.remove;

    final valueColor = Colors.black;

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
          Text(time, style: TextStyle(fontSize: 13, color: textBg)),
        ],
      ),
    );
  }
}
