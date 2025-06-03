import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/page5.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class dataBox extends StatefulWidget {
  const dataBox({super.key});

  @override
  State<dataBox> createState() => _dataBoxState();
}

class _dataBoxState extends State<dataBox> {
  int streak = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInrData();
  }

  Future<void> _loadInrData() async {
    final inrData = await Page2.getInrData(context);
    if (mounted) {
      setState(() {
        streak = inrData?.streak ?? 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la información de la dosis actual
    final doseInfo = Page5.getCurrentDoseInfo(context);

    // Si aún no hay datos, verificamos el proveedor directamente para intentar obtener algo
    final provider = Provider.of<MedicationConfigProvider>(
      context,
      listen: true,
    );
    final hasData = (provider.dosisGeneradas.isNotEmpty && doseInfo != null);

    final String message =
        doseInfo?.message ??
        ((provider.anticoagulante != null)
            ? "Cargando información de dosis..."
            : "Sin dosis programadas");

    final String medicamentoStr =
        doseInfo?.medicamento ?? provider.anticoagulante ?? "Sintrom";

    String dosisStr = "0 mg";
    String horaStr = "--:--";

    if (hasData) {
      dosisStr = doseInfo?.dosis ?? "0 mg";
      horaStr = doseInfo?.hora ?? "--:--";
    } else if (provider.dosisGeneradas.isNotEmpty) {
      // Intentamos obtener la dosis de hoy manualmente
      final hoy = DateTime.now();
      try {
        final dosisHoy = provider.dosisGeneradas.firstWhere(
          (d) =>
              d.fecha.year == hoy.year &&
              d.fecha.month == hoy.month &&
              d.fecha.day == hoy.day,
          orElse:
              () => DosisDiaria(
                fecha: hoy,
                dosis: 0,
                hora: '--:--',
                diaSemana: '',
              ),
        );

        dosisStr = "${dosisHoy.dosis} mg";
        horaStr = dosisHoy.hora;
      } catch (e) {
        // Si hay algún error, mantenemos los valores por defecto
      }
    }

    final bool tomada = doseInfo?.tomada ?? false;
    final bool retraso = message.contains("retras");

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Fondo semitransparente
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      tomada
                          ? Colors.green.shade100
                          : retraso
                          ? Colors.red.shade100
                          : Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tomada
                      ? Icons.check
                      : retraso
                      ? Icons.warning_amber_rounded
                      : Icons.access_time,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        text: "$medicamentoStr ",
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "$dosisStr - $horaStr",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      streak > 0
                          ? Colors.yellow.shade100
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  streak > 0 ? Icons.bolt : Icons.hourglass_empty,
                  color: streak > 0 ? Colors.orange : Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoading
                        ? "Cargando racha..."
                        : (streak > 0
                            ? "¡Racha de $streak días!"
                            : "No hay racha activa"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    streak > 0
                        ? "Sigue así, vas muy bien"
                        : "Mantén tus INR en rango",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(15),
          //   ),
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.refresh, color: Colors.white),
          //       SizedBox(width: 5),
          //       Text(
          //         "Sugerir dosis con IA",
          //         style: TextStyle(color: Colors.white, fontSize: 14),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
