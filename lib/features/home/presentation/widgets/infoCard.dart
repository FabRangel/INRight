import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildInfoCard("Último INR", "2.8", "En rango", Colors.green),
          const SizedBox(height: 10),
          _buildInfoCard("Cumplimiento", "98%", "7 días", Colors.green),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String subtitle,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.check_circle, color: statusColor, size: 14),
              const SizedBox(width: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
