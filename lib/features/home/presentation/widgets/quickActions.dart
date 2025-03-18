import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            "Acciones rápidas",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionItem(
                Icons.access_time,
                "Registrar\ndosis",
                const Color.fromARGB(255, 204, 232, 255),
              ),
              _buildActionItem(
                Icons.remove_red_eye,
                "Ver\ntendencia",
                const Color.fromARGB(255, 217, 251, 220),
              ),
              _buildActionItem(
                Icons.calendar_today,
                "Siguiente\nprueba",
                const Color.fromARGB(255, 251, 255, 196),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📌 Función para construir cada botón de acción
    Widget _buildActionItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color, // Se asigna el color pasado como argumento
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
