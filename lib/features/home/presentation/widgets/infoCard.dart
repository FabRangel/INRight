import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  double lastInr = 0.0;
  String inrDate = "-- ---";
  bool isInRange = false;
  int streak = 0;
  bool isLoading = true;
  int cumplimientoPorcentaje = 0;

  @override
  void initState() {
    super.initState();
    _loadInrData();
  }

  Future<void> _loadInrData() async {
    final inrData = await Page2.getInrData(context);

    // Calcular el porcentaje de cumplimiento basado en dosis tomadas
    final provider = Provider.of<MedicationConfigProvider>(
      context,
      listen: false,
    );
    final historial = provider.dosisGeneradas;
    int porcentajeCumplimiento = 0;

    if (historial.isNotEmpty) {
      final tomadasCount = historial.where((d) => d.tomada).length;
      porcentajeCumplimiento =
          ((tomadasCount * 100) / historial.length).round();
    }

    if (mounted) {
      setState(() {
        lastInr = inrData?.value ?? 0.0;
        inrDate = inrData?.date ?? "-- ---";
        isInRange = inrData?.isInRange ?? false;
        streak = inrData?.streak ?? 0;
        cumplimientoPorcentaje = porcentajeCumplimiento;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usar el porcentaje de cumplimiento calculado con la misma fórmula que Page4
    final cumplimentoValue = isLoading ? "--" : "$cumplimientoPorcentaje%";

    // Para el subtítulo, usamos la información de los días que lleva tomando
    final tomas =
        Provider.of<MedicationConfigProvider>(
          context,
          listen: false,
        ).dosisGeneradas.where((d) => d.tomada).length;
    final cumplimentoSubtitle = isLoading ? "Calculando" : "$tomas dosis";

    return Container(
      child: Column(
        children: [
          _buildInfoCard(
            "Último INR",
            isLoading ? "--" : lastInr.toStringAsFixed(1),
            isLoading
                ? "Cargando..."
                : (isInRange ? "En rango" : "Fuera de rango"),
            isInRange ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            "Cumplimiento",
            cumplimentoValue,
            cumplimentoSubtitle,
            cumplimientoPorcentaje > 80
                ? Colors.green
                : cumplimientoPorcentaje > 50
                ? Colors.orange
                : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String subtitle,
    Color statusColor,
  ) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                isLoading
                    ? Icons.hourglass_empty
                    : (subtitle.contains("rango") || subtitle.contains("días")
                        ? (statusColor == Colors.green
                            ? Icons.check_circle
                            : Icons.warning)
                        : Icons.info),
                color: statusColor,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
