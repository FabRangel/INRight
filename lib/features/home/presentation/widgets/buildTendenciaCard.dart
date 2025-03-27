import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/tendenciaData.dart';
import 'package:fl_chart/fl_chart.dart';

class buildTendenciaCard extends StatelessWidget {
  const buildTendenciaCard({super.key});

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
            'Tendencia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Simulación de gráfico
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.green,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                    spots: [
                      FlSpot(0, 2.0),
                      FlSpot(1, 2.3),
                      FlSpot(2, 2.1),
                      FlSpot(3, 2.6),
                      FlSpot(4, 3.0),
                      FlSpot(5, 2.8),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              TendenciaData(label: 'Min', value: '2.0'),
              TendenciaData(label: 'Max', value: '3.0'),
              TendenciaData(label: 'Promedio', value: '2.8'),
            ],
          ),
          
        ],
      ),
    );
  }
}
