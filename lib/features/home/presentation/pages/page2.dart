import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/addInrForm.dart';
import 'package:inright/features/home/presentation/widgets/trendChart.dart';
import 'package:inright/features/home/presentation/widgets/historyItem.dart';
import 'package:inright/features/home/presentation/widgets/animatedHistoryItem.dart';
import 'package:inright/services/home/inr.service.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> historyData = [];
  String lastDate = '-- ---';
  String lastTime = '--:--';
  double lastValue = 0.0;
  double minValue = 0.0;
  double maxValue = 0.0;
  int streak = 0; // Nueva variable para la racha

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    _loadInrHistory();
  }

  Future<void> _loadInrHistory() async {
    final data = await InrService().getInrHistory();

    // Obtener el provider para el rango de INR configurado
    final configProvider = Provider.of<MedicationConfigProvider>(
      context,
      listen: false,
    );
    final inrRange = configProvider.inrRange;
    final minIdeal = inrRange.start;
    final maxIdeal = inrRange.end;

    // Calcular valores mínimo, máximo y último
    double min = double.infinity;
    double max = double.negativeInfinity;
    double last = 0.0;
    String date = '-- ---';
    String time = '--:--';
    int currentStreak = 0; // Inicializamos la racha

    if (data.isNotEmpty) {
      // El último valor es el primero del historial (ordenado descendente)
      last = data[0]['value']?.toDouble() ?? 0.0;
      final rawDate = data[0]['date'] ?? '-- ---';
      time = data[0]['time'] ?? '--:--';

      // Format date to "day month" format
      try {
        if (rawDate.contains('-')) {
          final parts = rawDate.split('-');
          if (parts.length == 3) {
            final DateTime dateObj = DateTime(
              int.parse(parts[0]), // year
              int.parse(parts[1]), // month
              int.parse(parts[2]), // day
            );

            // Format as "day month" using the Spanish month names
            final months = [
              'Ene',
              'Feb',
              'Mar',
              'Abr',
              'May',
              'Jun',
              'Jul',
              'Ago',
              'Sep',
              'Oct',
              'Nov',
              'Dic',
            ];
            date = "${dateObj.day} ${months[dateObj.month - 1]}";
          }
        }
      } catch (e) {
        print("Error formatting date: $e");
        // Keep the original date value if there's an error
      }

      // Buscar mínimo y máximo
      for (var item in data) {
        final value = item['value']?.toDouble() ?? 0.0;
        if (value < min) min = value;
        if (value > max) max = value;
      }

      // Calcular la racha de valores consecutivos dentro del rango
      for (var item in data) {
        final value = item['value']?.toDouble() ?? 0.0;
        final isInRange = value >= minIdeal && value <= maxIdeal;

        if (isInRange) {
          // Incrementar racha si está en rango
          currentStreak++;
        } else {
          // Romper la racha al encontrar un valor fuera de rango
          break;
        }
      }
    }

    // Si no hay datos, establecer valores predeterminados
    if (min == double.infinity) min = 0.0;
    if (max == double.negativeInfinity) max = 0.0;

    setState(() {
      historyData = data;
      lastValue = last;
      lastDate = date;
      lastTime = time;
      minValue = min;
      maxValue = max;
      streak = currentStreak;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el provider para el rango de INR configurado
    final configProvider = Provider.of<MedicationConfigProvider>(context);
    final inrRange = configProvider.inrRange;

    // Determinar si el último valor está dentro del rango
    final isInRange = lastValue >= inrRange.start && lastValue <= inrRange.end;
    final valueColor = isInRange ? Colors.green : Colors.red;

    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 249),
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: CustomWaveClipper(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: topPadding + 10,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFBFE8EE),
                        Color(0xFF62BFE4),
                        Color(0xFF72C1E0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Última medición",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${lastValue.toStringAsFixed(1)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lastDate,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            lastTime,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Mínimo",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${minValue.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Column(
                            children: [
                              const Text(
                                "Máximo",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${maxValue.toStringAsFixed(1)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: StatBox(
                              title: "Racha",
                              value: "$streak días",
                              valueColor: Colors.black,
                              isBold: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatBox(
                              title: "Más alto",
                              value: maxValue.toStringAsFixed(1),
                              valueColor: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: StatBox(
                              title: "Más bajo",
                              value: minValue.toStringAsFixed(1),
                              valueColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Trendchart(),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Historial de INR',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Rango: ${inrRange.start.toStringAsFixed(1)}-${inrRange.end.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...historyData.asMap().entries.map((entry) {
                              final value =
                                  entry.value['value']?.toDouble() ?? 0.0;
                              final isItemInRange =
                                  value >= inrRange.start &&
                                  value <= inrRange.end;

                              return AnimatedHistoryItem(
                                index: entry.key,
                                item: HistoryItem(
                                  value: value,
                                  date: entry.value['date'] ?? '',
                                  time: entry.value['time'] ?? '',
                                  trend: _determineTrend(
                                    entry.key,
                                    historyData,
                                  ),
                                  isInRange: isItemInRange,
                                ),
                              );
                            }),
                            if (historyData.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    'No hay registros de INR',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                final resultado = await showModalBottomSheet(
                  isDismissible: true,
                  enableDrag: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: const AddInrForm(),
                    );
                  },
                );

                if (resultado == "guardado") {
                  await _loadInrHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: '¡Listo!',
                        color: Colors.green,
                        message:
                            'El valor de INR fue registrado correctamente.',
                        contentType: ContentType.success,
                        inMaterialBanner: true,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFF72C1E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para determinar la tendencia comparando con el valor anterior
  String _determineTrend(int index, List<Map<String, dynamic>> data) {
    if (index >= data.length - 1) return 'neutral';

    final currentValue = data[index]['value']?.toDouble() ?? 0.0;
    final prevValue = data[index + 1]['value']?.toDouble() ?? 0.0;

    if (currentValue > prevValue) {
      return 'up';
    } else if (currentValue < prevValue) {
      return 'down';
    } else {
      return 'neutral';
    }
  }
}

class CustomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(3, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height,
      size.width,
      size.height * 0.79,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final bool isBold;
  final double maxHeight;

  const StatBox({
    Key? key,
    required this.title,
    required this.value,
    required this.valueColor,
    this.isBold = false,
    this.maxHeight = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
