import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/features/home/providers/inrProvider.dart';
import 'package:provider/provider.dart';

class NextINRCardWidget extends StatelessWidget {
  const NextINRCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inrProvider = Provider.of<InrProvider>(context);
    final configProvider = Provider.of<MedicationConfigProvider>(context);

    // Obtener la última medición
    final historial = inrProvider.inrDatos;
    DateTime? fechaUltimoInr;

    if (historial.isNotEmpty && historial.first['date'] != null) {
      try {
        final partes = historial.first['date'].toString().split('-');
        if (partes.length == 3) {
          fechaUltimoInr = DateTime(
            int.parse(partes[0]),
            int.parse(partes[1]),
            int.parse(partes[2]),
          );
        }
      } catch (e) {
        // Si hay error, deja fechaUltimoInr como null
      }
    }

    // Calcular la próxima
    String textoFecha = "Aún no has registrado una prueba INR";
    if (fechaUltimoInr != null) {
      final proxima = fechaUltimoInr.add(
        Duration(days: configProvider.frecuenciaInr),
      );
      final format = DateFormat("d MMM", "es");
      textoFecha = "Próxima toma de INR: ${format.format(proxima)}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_today, color: Colors.black),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                textoFecha,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
