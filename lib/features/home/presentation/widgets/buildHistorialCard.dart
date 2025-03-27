import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/dosisItem.dart';
import 'package:inright/features/home/presentation/widgets/historyItem.dart';

enum FiltroHistorial { todo, inr, dosis }

class buildHistorialCard extends StatefulWidget {
  const buildHistorialCard({super.key});

  @override
  State<buildHistorialCard> createState() => _HistorialSectionState();
}

class _HistorialSectionState extends State<buildHistorialCard> {
  FiltroHistorial filtroSeleccionado = FiltroHistorial.todo;

  final List<Map<String, dynamic>> historial = [
    {
      'tipo': 'inr',
      'valor': 2.8,
      'fecha': '15 Ene',
      'hora': '09:00',
      'trend': 'neutral',
    },
    {'tipo': 'dosis', 'dosis': '5mg', 'fecha': '15 Ene', 'hora': '09:00'},
    {
      'tipo': 'inr',
      'valor': 3.1,
      'fecha': '01 Ene',
      'hora': '09:15',
      'trend': 'up',
    },
    {'tipo': 'dosis', 'dosis': '4mg', 'fecha': '01 Ene', 'hora': '09:15'},
    {
      'tipo': 'inr',
      'valor': 2.5,
      'fecha': '15 Dic',
      'hora': '08:45',
      'trend': 'down',
    },
    {'tipo': 'dosis', 'dosis': '5mg', 'fecha': '15 Dic', 'hora': '08:45'},
    {
      'tipo': 'inr',
      'valor': 2.7,
      'fecha': '01 Dic',
      'hora': '09:30',
      'trend': 'neutral',
    },
    {'tipo': 'dosis', 'dosis': '5mg', 'fecha': '01 Dic', 'hora': '09:30'},
  ];

  @override
  Widget build(BuildContext context) {
    final historialFiltrado =
        historial.where((item) {
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
          ...historialFiltrado.map((item) {
            if (item['tipo'] == 'inr') {
              return HistoryItem(
                value: item['valor'],
                date: item['fecha'],
                time: item['hora'],
                trend: item['trend'],
              );
            } else {
              return DosisItem(
                dosis: item['dosis'],
                date: item['fecha'],
                time: item['hora'],
              );
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
