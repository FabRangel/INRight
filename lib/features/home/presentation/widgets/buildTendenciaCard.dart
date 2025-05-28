import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/tendenciaData.dart';
import 'package:fl_chart/fl_chart.dart';

class BuildTendenciaCard extends StatelessWidget {
  final List<double> valoresInr;

  const BuildTendenciaCard({super.key, required this.valoresInr});

  @override
  Widget build(BuildContext context) {
    if (valoresInr.isEmpty) {
      return const Text("No hay datos suficientes");
    }

    final min = valoresInr.reduce((a, b) => a < b ? a : b);
    final max = valoresInr.reduce((a, b) => a > b ? a : b);
    final avg = valoresInr.reduce((a, b) => a + b) / valoresInr.length;

    final spots = List.generate(
      valoresInr.length,
      (index) => FlSpot(index.toDouble(), valoresInr[index]),
    );

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
                    spots: spots,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TendenciaData(label: 'Min', value: min.toStringAsFixed(1)),
              TendenciaData(label: 'Max', value: max.toStringAsFixed(1)),
              TendenciaData(label: 'Promedio', value: avg.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}
