import 'package:flutter/material.dart';
import 'package:inright/features/home/providers/inrProvider.dart';
import 'package:inright/features/home/presentation/widgets/tendenciaData.dart';
import 'package:inright/features/home/presentation/widgets/legendItem.dart';
import 'package:inright/features/home/presentation/widgets/buildEstabilidadCard.dart';
import 'package:inright/features/home/presentation/widgets/buildTendenciaCard.dart';
import 'package:inright/features/home/presentation/widgets/buildHistorialCard.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  String modoSeleccionado = 'Semanal';
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<InrProvider>(context, listen: false);
      provider.fetchInr();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPage(int pageIndex) {
    // 24 ancho + 12 spacing * 7 barras + 16 de padding por grupo
    final offset = pageIndex * ((24.0 + 12.0) * 7 + 16);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🟦 Header fijo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 191, 232, 238),
                  Color.fromARGB(255, 98, 191, 228),
                  Color.fromARGB(255, 114, 193, 224),
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
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Análisis\nINR',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildModeButton('7 Registros', ModoInr.semanal),
                        const SizedBox(width: 4),
                        _buildModeButton('31 Registros', ModoInr.mensual),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Promedio',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Consumer<InrProvider>(
                        builder: (context, provider, child) {
                          if (provider.loading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return Text(
                            provider.promedio.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          LegendItem(color: Colors.green, label: 'Normal'),
                          SizedBox(width: 16),
                          LegendItem(
                            color: Colors.red,
                            label: 'Fuera de\nrango',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Consumer<InrProvider>(
                        builder: (context, provider, child) {
                          if (provider.loading) {
                            return const SizedBox(
                              height: 160,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final datos = provider.inrFiltrado;
                          final isMensual = provider.modo == ModoInr.mensual;

                          final maxValue = datos
                              .where((e) => e['value'] != null)
                              .map((e) => (e['value'] as num).toDouble())
                              .fold<double>(
                                0.0,
                                (prev, val) => val > prev ? val : prev,
                              );

                          final datosCopiados = List<Map<String, dynamic>>.from(
                            datos,
                          );
                          final groups = <List<Map<String, dynamic>>>[];

                          for (int i = 0; i < datosCopiados.length; i += 7) {
                            final end =
                                (i + 7 > datosCopiados.length)
                                    ? datosCopiados.length
                                    : i + 7;
                            final group = datosCopiados.sublist(i, end);

                            // Rellenar solo el último grupo si tiene menos de 7
                            if (group.length < 7 &&
                                i + 7 >= datosCopiados.length) {
                              while (group.length < 7) {
                                group.add({'value': null, 'date': ''});
                              }
                            }

                            groups.add(group);
                          }

                          final pageCount = groups.length;

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final pageWidth = constraints.maxWidth;

                              return SizedBox(
                                height: 160,
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: pageCount,
                                      itemBuilder: (context, index) {
                                        final grupo = groups[index];

                                        // Cálculo de espacio dinámico
                                        const spacing = 12.0;
                                        final totalSpacing =
                                            spacing * (grupo.length - 1);
                                        final barWidth =
                                            (pageWidth - totalSpacing) /
                                            grupo.length;

                                        return SizedBox(
                                          width:
                                              pageWidth, // ← fuerza a ocupar todo el ancho
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children:
                                                grupo.map((e) {
                                                  return _buildBar(
                                                    e,
                                                    maxValue,
                                                    barWidth,
                                                  );
                                                }).toList(),
                                          ),
                                        );
                                      },
                                    ),

                                    // ← Flecha izquierda
                                    if (_currentPage > 0)
                                      Positioned(
                                        left: 0,
                                        top: 50,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _scrollToPage(
                                                _currentPage - 1,
                                              ),
                                        ),
                                      ),

                                    // → Flecha derecha
                                    if (_currentPage < pageCount - 1)
                                      Positioned(
                                        right: 0,
                                        top: 50,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _scrollToPage(
                                                _currentPage + 1,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔄 Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 100),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildEstabilidadCard()),
                      const SizedBox(width: 16),
                      Expanded(child: buildTendenciaCard()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  buildHistorialCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildModeButton(String label, ModoInr modo) {
    return Consumer<InrProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.modo == modo;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentPage = 0;
            });
            provider.setModo(modo);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildBar(Map<String, dynamic> data, double maxValue, double width) {
  final value = data['value'];
  final fecha = data['date'];

  if (value == null) {
    // Espacio vacío
    return SizedBox(
      width: width,
      height: 80,
      child: const Center(
        child: Text('-', style: TextStyle(color: Colors.white38, fontSize: 12)),
      ),
    );
  }

  final double val = (value as num).toDouble();
  final barHeight = maxValue == 0 ? 0 : (val / maxValue) * 80;
  final barColor = val >= 2.0 && val <= 3.0 ? Colors.green : Colors.red;

  String fechaCorta = '';
  if (fecha is String && fecha.contains('-')) {
    // formato yyyy-mm-dd → mm/dd
    final partes = fecha.split('-');
    if (partes.length == 3) {
      fechaCorta = '${partes[1]}/${partes[2]}';
    }
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: width,
        height: barHeight.toDouble(),
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        val.toStringAsFixed(1),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      Text(
        fechaCorta,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      ),
    ],
  );
}

List<Widget> _buildBars() {
  final data = [
    {'date': '27\nfeb', 'value': 2.7, 'normal': true},
    {'date': '26\nfeb', 'value': 3.5, 'normal': false},
    {'date': '25\nfeb', 'value': 2.6, 'normal': true},
    {'date': '24\nfeb', 'value': 2.7, 'normal': true},
    {'date': '23\nfeb', 'value': 2.5, 'normal': true},
    {'date': '22\nfeb', 'value': 2.9, 'normal': true},
    {'date': '21\nfeb', 'value': 2.6, 'normal': true},
  ];

  return data.map((entry) {
    final barHeight = (entry['value'] as double) * 15;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: barHeight,
          decoration: BoxDecoration(
            color:
                (entry['normal']! as bool)
                    ? const Color.fromARGB(255, 63, 179, 104)
                    : Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry['date']! as String,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }).toList();
}

List<Widget> buildBarsFromData(List<double> values) {
  final maxValue =
      values.isEmpty ? 1.0 : values.reduce((a, b) => a > b ? a : b);
  return values.map((value) {
    final isInRange = value >= 2.0 && value <= 3.0;
    return Flexible(
      child: Container(
        height: (value / maxValue) * 100, // Altura proporcional
        decoration: BoxDecoration(
          color: isInRange ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }).toList();
}
