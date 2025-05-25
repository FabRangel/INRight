import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:inright/features/home/domain/providers/medication_config_provider.dart';

/// Página que muestra la próxima dosis, su estatus y el historial agrupado.
class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String message = '';
  Timer? timer;
  bool hasNotified = false; // evita spam de notificaciones

  final FlutterLocalNotificationsPlugin _notifier =
      FlutterLocalNotificationsPlugin();

  // ───────────────────────────── CICLO DE VIDA ─────────────────────────────
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    //--- Espera al primer frame y *luego* genera las dosis ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MedicationConfigProvider>(
        context,
        listen: false,
      );
      provider
        ..generarDosisSegunEsquema(silent: true)
        ..marcarFaltas(); // ← esto pone estado = 'falta' a las pasadas
    });

    // notificaciones locales (sin cambios)
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    _notifier.initialize(initSettings);

    Future.microtask(_inicializarMensajeYTimer);
  }

  void _inicializarMensajeYTimer() {
    final provider = Provider.of<MedicationConfigProvider>(
      context,
      listen: false,
    );
    final hoy = DateTime.now();
    final dosisHoy = provider.dosisGeneradas.firstWhere(
      (d) => _esMismoDia(d.fecha, hoy),
      orElse:
          () => DosisDiaria(fecha: hoy, dosis: 0, hora: '00:00', diaSemana: ''),
    );

    setState(() => message = _getDoseMessage(dosisHoy.hora));

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final nuevo = _getDoseMessage(dosisHoy.hora);
      if (nuevo != message) setState(() => message = nuevo);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  // ─────────────────────────────── BUILD ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicationConfigProvider>(context);
    final dosis = provider.dosisGeneradas;

    final hoy = DateTime.now();
    final proxima = dosis.firstWhere(
      (d) => _esMismoDia(d.fecha, hoy),
      orElse:
          () => DosisDiaria(fecha: hoy, dosis: 0, hora: '00:00', diaSemana: ''),
    );

    final grouped = <String, List<DosisDiaria>>{};
    for (var d in dosis) {
      final label = _getRelativeDateLabel(d.fecha);
      grouped.putIfAbsent(label, () => []).add(d);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: Column(
        children: [
          _buildHeader(proxima),
          _buildStatusAndConfirm(provider),
          _buildDoseHistory(grouped),
        ],
      ),
    );
  }

  // ────────────────────────────── HEADER ──────────────────────────────────
  Widget _buildHeader(DosisDiaria proxima) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBFE8EE), Color(0xFF62BFE4), Color(0xFF72C1E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Column(
        children: [
          const Text(
            'Próxima dosis',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            '${proxima.dosis} mg',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                proxima.hora,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────── STATUS ─────────────────────────────────
  Widget _buildStatusAndConfirm(MedicationConfigProvider provider) {
    final hoy = DateTime.now();
    final dosisHoy = provider.dosisGeneradas.firstWhere(
      (d) => _esMismoDia(d.fecha, hoy),
      orElse:
          () => DosisDiaria(fecha: hoy, dosis: 0, hora: '00:00', diaSemana: ''),
    );

    final colores = _colorsForMessage(message);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colores['bg'],
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(colores['icon'], color: colores['fg']),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colores['fg'],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (dosisHoy.tomada) {
                  setState(() {
                    dosisHoy
                      ..tomada = false
                      ..horaToma = null
                      ..estado = 'pendiente';
                  });
                  _showSnack(
                    'Toma cancelada',
                    'Has desconfirmado tu dosis.',
                    ContentType.warning,
                  );
                } else {
                  provider.confirmarTomaDelDia();
                  dosisHoy
                    ..tomada = true
                    ..horaToma = DateTime.now()
                    ..estado = 'ok';
                  _showDelayedNotification();
                  if (!hasNotified) {
                    _showDelayedNotification();
                    hasNotified = true;
                  }
                  setState(() {
                    final siguiente = _buscarSiguienteDosis(
                      provider,
                      DateTime.now(),
                    );
                    if (siguiente != null) {
                      final diff = siguiente.difference(DateTime.now());
                      message =
                          'Faltan ${diff.inHours}h ${diff.inMinutes % 60}m para tu próxima dosis';
                    }
                  });
                  _showSnack(
                    '¡Toma registrada!',
                    'Has confirmado tu dosis correctamente.',
                    ContentType.success,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    dosisHoy.tomada
                        ? const Color.fromARGB(255, 160, 157, 157)
                        : Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Icon(
                dosisHoy.tomada ? Icons.cancel : Icons.check_circle,
                size: 24,
                color: Colors.white,
              ),
              label: Text(
                dosisHoy.tomada ? 'Cancelar toma' : 'Confirmar toma',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────── HISTORIAL ────────────────────────────────
  Widget _buildDoseHistory(Map<String, List<DosisDiaria>> grouped) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Column(
          children:
              grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...entry.value.map(_buildDoseTile).toList(),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildDoseTile(DosisDiaria d) {
    final estado = d.estado.trim().toLowerCase();
    final bgColor =
        d.tomada
            ? const Color(0xFFE7F8EB)
            : (estado == 'falta'
                ? const Color(0xFFFFE0E0)
                : const Color(0xFFFFF3CD));
    final icon =
        d.tomada
            ? Icons.check
            : (estado == 'falta' ? Icons.cancel : Icons.access_time);
    final iconColor =
        d.tomada
            ? Colors.green
            : (estado == 'falta' ? Colors.red : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${d.dosis} mg',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _estadoLegible(d),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            d.horaToma != null
                ? '${d.horaToma!.hour.toString().padLeft(2, '0')}:${d.horaToma!.minute.toString().padLeft(2, '0')}'
                : d.hora,
            style: TextStyle(fontWeight: FontWeight.w500, color: iconColor),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────── UTILIDADES ──────────────────────────────
  Map<String, dynamic> _colorsForMessage(String msg) {
    if (msg.contains('retraso') || msg.contains('Te retrasaste')) {
      return {
        'bg': const Color(0xFFFFE0E0),
        'fg': Colors.red,
        'icon': Icons.warning_amber_rounded,
      };
    } else if (msg.contains('hora de tu dosis')) {
      return {
        'bg': const Color(0xFFFFF3CD),
        'fg': Colors.orange,
        'icon': Icons.access_time,
      };
    } else {
      return {
        'bg': const Color(0xFFE7F8EB),
        'fg': Colors.green,
        'icon': Icons.access_time,
      };
    }
  }

  String _getDoseMessage(String doseTimeStr) {
    final now = DateTime.now();
    final provider = Provider.of<MedicationConfigProvider>(
      context,
      listen: false,
    );

    // a) Si la dosis de hoy está confirmada → mostrar siguiente pendiente
    final dosisHoy = provider.dosisGeneradas.firstWhere(
      (d) => _esMismoDia(d.fecha, now),
      orElse:
          () => DosisDiaria(fecha: now, dosis: 0, hora: '00:00', diaSemana: ''),
    );

    if (dosisHoy.tomada) {
      final siguiente = _buscarSiguienteDosis(provider, now);
      if (siguiente == null) return 'No hay próximas dosis programadas';

      final diff = siguiente.difference(now);
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return 'Faltan ${h}h ${m}m para tu próxima dosis';
    }

    // b) Si todavía no la has tomado → lógica de antes
    final partes = doseTimeStr.split(':');
    final fechaHoraDosis = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );

    if (fechaHoraDosis.isAfter(now)) {
      final diff = fechaHoraDosis.difference(now);
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return 'Faltan ${h}h ${m}m para tu dosis';
    }

    final retraso = now.difference(fechaHoraDosis);
    final h = retraso.inHours;
    final m = retraso.inMinutes % 60;
    return 'Te retrasaste ${h}h ${m}m';
  }

  /// Devuelve la fecha/hora de la siguiente dosis pendiente después de `desde`.
  DateTime? _buscarSiguienteDosis(MedicationConfigProvider p, DateTime desde) {
    final pendientes =
        p.dosisGeneradas.where((d) {
            if (d.tomada) return false;
            final partes = d.hora.split(':');
            final fh = DateTime(
              d.fecha.year,
              d.fecha.month,
              d.fecha.day,
              int.parse(partes[0]),
              int.parse(partes[1]),
            );
            return fh.isAfter(desde);
          }).toList()
          ..sort((a, b) {
            DateTime fa(DosisDiaria d) {
              final parts = d.hora.split(':');
              return DateTime(
                d.fecha.year,
                d.fecha.month,
                d.fecha.day,
                int.parse(parts[0]),
                int.parse(parts[1]),
              );
            }

            return fa(a).compareTo(fa(b));
          });

    if (pendientes.isEmpty) return null;

    final prox = pendientes.first;
    final pParts = prox.hora.split(':');
    return DateTime(
      prox.fecha.year,
      prox.fecha.month,
      prox.fecha.day,
      int.parse(pParts[0]),
      int.parse(pParts[1]),
    );
  }

  void _showSnack(String title, String msg, ContentType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: msg,
          contentType: type,
        ),
      ),
    );
  }

  Future<void> _showDelayedNotification() async {
    const android = AndroidNotificationDetails(
      'dose_channel',
      'Dosis Retrasada',
      channelDescription: 'Te notifica si olvidaste tu dosis',
      importance: Importance.max,
      priority: Priority.high,
    );
    await _notifier.show(
      0,
      '¡Dosis retrasada!',
      'Ya pasó la hora de tomar tu medicamento',
      NotificationDetails(android: android),
    );
  }

  bool _esMismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _estadoLegible(DosisDiaria d) {
    final hoy = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final fechaD = DateTime(d.fecha.year, d.fecha.month, d.fecha.day);

    if (d.tomada) {
      return 'Tomada a las ${d.horaToma!.hour.toString().padLeft(2, '0')}:${d.horaToma!.minute.toString().padLeft(2, '0')}';
    } else if (fechaD.isBefore(hoy)) {
      return 'FALTA';
    }
    return 'PENDIENTE';
  }

  String _getRelativeDateLabel(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
    if (diff == 2) return 'Antier';
    return '${date.day}/${date.month}/${date.year}';
  }
}
