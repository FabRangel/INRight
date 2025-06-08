import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/home/providers/inrProvider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';

class NextINRCardWidget extends StatelessWidget {
  const NextINRCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final inrProvider = Provider.of<InrProvider>(context);
    final configProvider = Provider.of<MedicationConfigProvider>(context);

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
        fechaUltimoInr = null;
      }
    }

    final now = DateTime.now();
    String mensaje = "Aún no has registrado una prueba INR";
    Color fondo = Colors.grey.shade300;
    IconData icono = Icons.access_time;

    if (fechaUltimoInr != null) {
      final proxima = fechaUltimoInr.add(
        Duration(days: configProvider.frecuenciaInr),
      );
      final hoy = DateTime(now.year, now.month, now.day);
      final diaPrueba = DateTime(proxima.year, proxima.month, proxima.day);

      final formato = DateFormat("d MMM", "es");

      if (diaPrueba.isBefore(hoy)) {
        mensaje = "¡Tu prueba de INR está atrasada!";
        fondo = Colors.red.shade100;
        icono = Icons.error;
      } else if (diaPrueba.isAtSameMomentAs(hoy)) {
        mensaje = "Hoy debes realizar tu prueba de INR";
        fondo = Colors.yellow.shade100;
        icono = Icons.warning_amber;
      } else {
        mensaje = "Próxima toma de INR: ${formato.format(diaPrueba)}";
        fondo = Colors.blue.shade100;
        icono = Icons.calendar_today;
      }
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
                color: fondo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, color: Colors.black87),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
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
