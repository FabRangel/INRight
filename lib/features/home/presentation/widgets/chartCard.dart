import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/services/home/inr.service.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({Key? key}) : super(key: key);

  @override
  _ChartCard createState() => _ChartCard();
}

class _ChartCard extends State<ChartCard> {
  bool isLineal = true;
  List<Map<String, dynamic>> chartData = [];
  bool isLoading = true;
  double minY = 0;
  double maxY = 5;
  RangeValues inrRange = const RangeValues(2.0, 3.0);

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    try {
      final data = await InrService().getInrHistory();

      // Obtener el rango de INR para las líneas de referencia
      final provider = Provider.of<MedicationConfigProvider>(
        context,
        listen: false,
      );
      final range = provider.inrRange;

      // Ordenamos por fecha ascendente para la gráfica
      data.sort((a, b) {
        final dateA = a['date'] ?? '';
        final dateB = b['date'] ?? '';
        return dateA.compareTo(dateB);
      });

      if (data.isNotEmpty) {
        // Encontrar min y max para escala del gráfico
        double min = double.infinity;
        double max = double.negativeInfinity;

        for (var item in data) {
          final value = item['value']?.toDouble() ?? 0.0;
          if (value < min) min = value;
          if (value > max) max = value;
        }

        // Añadir margen
        min = (min - 0.5).clamp(0.0, double.infinity);
        max = max + 0.5;

        // Limitar a los últimos 7 registros para la visualización
        final limitedData =
            data.length > 7 ? data.sublist(data.length - 7) : data;

        setState(() {
          chartData = limitedData;
          minY = min;
          maxY = max;
          inrRange = RangeValues(range.start, range.end);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para formatear las fechas en formato DD/MM
  String _formatDateLabel(String dateStr) {
    if (dateStr.isEmpty || !dateStr.contains('-')) {
      return '';
    }

    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        // Formato yyyy-mm-dd
        final day = parts[2];
        final month = parts[1];
        return '$day/$month';
      }
    } catch (e) {
      // En caso de error devolver cadena vacía
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
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
          // 📌 Título y pestañas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mi INR",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // 🔹 Botones de pestañas (Lineal / Barras)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      "Lineal",
                      isActive: isLineal,
                      onTap: () {
                        setState(() {
                          isLineal = true;
                        });
                      },
                    ),
                    _buildTabButton(
                      "Barras",
                      isActive: !isLineal,
                      onTap: () {
                        setState(() {
                          isLineal = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Gráfica real
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child:
                isLoading
                    ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : chartData.isEmpty
                    ? const Center(
                      child: Text(
                        "No hay datos para mostrar",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                    : isLineal
                    ? _buildLineChart()
                    : _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < chartData.length) {
                  // Usar el formato DD/MM en lugar de solo el día
                  final String date = chartData[value.toInt()]['date'] ?? '';
                  return Text(
                    _formatDateLabel(date),
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
                  );
                }
                return const Text('');
              },
              reservedSize: 20,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: chartData.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: inrRange.start,
              color: Colors.green.withOpacity(0.5),
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: inrRange.end,
              color: Colors.green.withOpacity(0.5),
              dashArray: [5, 5],
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(chartData.length, (index) {
              return FlSpot(
                index.toDouble(),
                chartData[index]['value']?.toDouble() ?? 0.0,
              );
            }),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final value = chartData[index]['value']?.toDouble() ?? 0.0;
                final isInRange =
                    value >= inrRange.start && value <= inrRange.end;
                return FlDotCirclePainter(
                  radius: 4,
                  color: isInRange ? Colors.green : Colors.red,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < chartData.length) {
                  // Usar el formato DD/MM en lugar de solo el día
                  final String date = chartData[value.toInt()]['date'] ?? '';
                  return Text(
                    _formatDateLabel(date),
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
                  );
                }
                return const Text('');
              },
              reservedSize: 20,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: minY,
        maxY: maxY,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: inrRange.start,
              color: Colors.green.withOpacity(0.5),
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: inrRange.end,
              color: Colors.green.withOpacity(0.5),
              dashArray: [5, 5],
            ),
          ],
        ),
        barGroups: List.generate(chartData.length, (index) {
          final value = chartData[index]['value']?.toDouble() ?? 0.0;
          final isInRange = value >= inrRange.start && value <= inrRange.end;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 12,
                color: isInRange ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 📌 Función para los botones de pestañas (Lineal / Barras)
  Widget _buildTabButton(
    String text, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // 🔹 Hacemos que el botón sea interactivo
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.black54,
          ),
        ),
      ),
    );
  }
}
