import 'package:flutter/material.dart';

class ItemHistorial extends StatelessWidget {
  final String estado; // ok | tarde | falta
  final String dosis;
  final String hora;
  final String fecha;

  const ItemHistorial({
    super.key,
    required this.estado,
    required this.dosis,
    required this.hora,
    required this.fecha,
  });

  Color get _background {
    switch (estado) {
      case 'ok':
        return Colors.green.shade50;
      case 'tarde':
        return Colors.amber.shade50;
      case 'falta':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color get _horaColor {
    switch (estado) {
      case 'ok':
        return Colors.green;
      case 'tarde':
        return Colors.amber[800]!;
      case 'falta':
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  IconData get _icon {
    switch (estado) {
      case 'ok':
        return Icons.check_circle_outline;
      case 'tarde':
        return Icons.schedule;
      case 'falta':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final horaMostrar = estado == 'falta' ? '--:--' : hora;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_icon, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dosis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(fecha, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Text(
            horaMostrar,
            style: TextStyle(fontWeight: FontWeight.bold, color: _horaColor),
          ),
        ],
      ),
    );
  }
}
