import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inright/services/home/inr.service.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class Trendchart extends StatefulWidget {
  const Trendchart({super.key});

  @override
  State<Trendchart> createState() => _TrendchartState();
}

class _TrendchartState extends State<Trendchart> {
  final InrService _inrService = InrService();
  List<Map<String, dynamic>> _inrData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInrHistory();
  }

  Future<void> _loadInrHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _inrService.getInrHistory();

      // Group data by date to prevent showing dates without points
      final Map<String, List<double>> valuesByDate = {};

      // Process and group the data
      for (var item in data) {
        final date = item['date'] as String? ?? '';
        final value = item['value']?.toDouble() ?? 0.0;

        if (!valuesByDate.containsKey(date)) {
          valuesByDate[date] = [];
        }
        valuesByDate[date]!.add(value);
      }

      // Create new clean data array with only dates that have values
      final List<Map<String, dynamic>> cleanedData = [];
      valuesByDate.forEach((date, values) {
        for (var value in values) {
          cleanedData.add({'date': date, 'value': value});
        }
      });

      // Sort the cleaned data
      cleanedData.sort((a, b) {
        final dateA = a['date'] as String? ?? '';
        final dateB = b['date'] as String? ?? '';
        return dateA.compareTo(dateB);
      });

      if (mounted) {
        setState(() {
          _inrData = cleanedData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error cargando historial INR: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_inrData.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          children: [
            Text(
              'Tendencia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 40),
            Text(
              'No hay datos de INR registrados',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 40),
          ],
        ),
      );
    }

    // Obtener el rango de INR objetivo desde el provider
    final configProvider = Provider.of<MedicationConfigProvider>(context);
    final inrRange = configProvider.inrRange;
    final minIdeal = inrRange.start;
    final maxIdeal = inrRange.end;

    // Agrupar valores por fecha
    final Map<String, List<double>> valuesByDate = {};

    for (var item in _inrData) {
      final String date = item['date'] as String? ?? '';
      final double value = item['value']?.toDouble() ?? 0.0;

      if (!valuesByDate.containsKey(date)) {
        valuesByDate[date] = [];
      }
      valuesByDate[date]!.add(value);
    }

    // Ordenar fechas para mantener cronología
    final List<String> orderedDates = valuesByDate.keys.toList()..sort();

    // Crear puntos para la gráfica
    final spots = <ScatterSpot>[];
    int xPosition = 0;

    for (var date in orderedDates) {
      final values = valuesByDate[date]!;

      for (var value in values) {
        final dotColor =
            (value >= minIdeal && value <= maxIdeal)
                ? Colors.green
                : Colors.red;
        spots.add(
          ScatterSpot(
            xPosition.toDouble(),
            value,
            dotPainter: FlDotCirclePainter(
              color: dotColor,
              radius: 8,
              strokeWidth: 1,
              strokeColor: Colors.white,
            ),
          ),
        );
      }

      xPosition++; // Incrementar posición X solo una vez por fecha
    }

    // Calcular valores mínimos y máximos para el eje Y
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var spot in spots) {
      if (spot.y < minY) minY = spot.y;
      if (spot.y > maxY) maxY = spot.y;
    }

    // Añadir margen para mejor visualización
    minY = (minY - 0.3).clamp(0, double.infinity);
    maxY = maxY + 0.3;

    // Preparar etiquetas de fechas
    final List<String> labels =
        orderedDates.map((date) {
          final parts = date.split('-');
          if (parts.length == 3) {
            return "${parts[2]}/${parts[1]}"; // DD/MM
          }
          return '';
        }).toList();

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tendencia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: _loadInrHistory,
                child: const Icon(Icons.refresh, size: 20, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gráfico - Ahora solo puntos sin cuadrícula, agrupados por fecha
          AspectRatio(
            aspectRatio: 2,
            child: ScatterChart(
              ScatterChartData(
                // Ensure we only show dates with actual data points
                scatterSpots: spots,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        // Format to show only dates that have corresponding points
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 0.5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                minX: -0.5,
                maxX:
                    orderedDates.length -
                    0.5, // Ajustar según el número real de fechas
                minY: minY,
                maxY: maxY,
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  touchTooltipData: ScatterTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                    getTooltipItems: (touchedSpot) {
                      // Añadir la fecha correspondiente al tooltip
                      final int xIndex = touchedSpot.x.toInt();
                      String dateInfo = '';
                      if (xIndex >= 0 && xIndex < labels.length) {
                        dateInfo = ' (${labels[xIndex]})';
                      }

                      return ScatterTooltipItem(
                        '${touchedSpot.y.toStringAsFixed(1)}$dateInfo',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Leyenda para explicar los colores
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('En rango', Colors.green),
              const SizedBox(width: 20),
              _buildLegendItem('Fuera de rango', Colors.red),
            ],
          ),

          // Añadir información de múltiples valores por día
          if (_hasMultipleValuesInSameDay(valuesByDate))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  'Nota: Algunos días tienen múltiples registros',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Método auxiliar para verificar si hay días con múltiples valores
  bool _hasMultipleValuesInSameDay(Map<String, List<double>> valuesByDate) {
    return valuesByDate.values.any((list) => list.length > 1);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
