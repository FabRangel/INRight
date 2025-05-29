import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/dosisItem.dart';
import 'package:inright/features/home/presentation/widgets/historyItem.dart';

enum FiltroHistorial { todo, inr, dosis }

class HistorialCard extends StatefulWidget {
  final List<Map<String, dynamic>> historial;

  const HistorialCard({super.key, required this.historial});

  @override
  State<HistorialCard> createState() => _HistorialCardState();
}

class _HistorialCardState extends State<HistorialCard> {
  FiltroHistorial filtroSeleccionado = FiltroHistorial.todo;

  @override
  Widget build(BuildContext context) {
    final historialFiltrado =
        widget.historial.where((item) {
          if (filtroSeleccionado == FiltroHistorial.todo) return true;
          return item['tipo'] == filtroSeleccionado.name;
        }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y filtros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildFiltroButton(FiltroHistorial.todo, 'Todo'),
                  const SizedBox(width: 12),
                  _buildFiltroButton(FiltroHistorial.inr, 'INR'),
                  const SizedBox(width: 12),
                  _buildFiltroButton(FiltroHistorial.dosis, 'Dosis'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista renderizada
          if (historialFiltrado.isEmpty)
            const Text("Sin registros")
          else
            ...historialFiltrado.map((item) {
              if (item['tipo'] == 'inr' && item['valor'] != null) {
                return HistoryItem(
                  value: (item['valor'] as num).toDouble(),
                  date: item['fecha'],
                  time: item['hora'],
                  trend: item['trend'] ?? 'neutral',
                );
              } else if (item['tipo'] == 'dosis') {
                return DosisItem(
                  dosis: item['dosis'].toString(),
                  date: item['fecha'],
                  time: item['hora'],
                );
              } else {
                // Si es tipo desconocido o falta data
                return const SizedBox.shrink();
              }
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildFiltroButton(FiltroHistorial tipo, String label) {
    final bool isSelected = filtroSeleccionado == tipo;
    return GestureDetector(
      onTap: () {
        setState(() {
          filtroSeleccionado = tipo;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
