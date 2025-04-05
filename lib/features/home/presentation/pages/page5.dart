import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inright/features/home/presentation/widgets/animatedRegisterItem.dart';
import 'package:inright/features/home/presentation/widgets/registerItem.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isDelayed = false;
  late String message;
  late Timer timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool hasNotified = false; // Para evitar notificación duplicada

  final List<Map<String, dynamic>> registerData = [
    {
      "value": "4 mg",
      "period": "Mañana",
      "time": "09:00",
      "taken": false,
      "date": DateTime.now(), // Hoy
    },
    {
      "value": "4 mg",
      "period": "Mañana",
      "time": "09:00",
      "taken": true,
      "date": DateTime.now().subtract(const Duration(days: 1)), // Ayer
    },
    {
      "value": "4 mg",
      "period": "Noche",
      "time": "21:00",
      "taken": true,
      "date": DateTime.now().subtract(const Duration(days: 2)), // Antier
    },
  ];

  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Luego tu animación y timer:
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();

    final doseTime = registerData.first['time'];
    message = getDoseMessage(doseTime);

    // Actualizar cada minuto
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        message = getDoseMessage(doseTime);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  String getDoseMessage(String doseTimeStr) {
    final now = DateTime.now();
    final nowTime = TimeOfDay.fromDateTime(now);

    final parts = doseTimeStr.split(':');
    final doseHour = int.parse(parts[0]);
    final doseMinute = int.parse(parts[1]);
    final doseTime = TimeOfDay(hour: doseHour, minute: doseMinute);

    final nowInMinutes = nowTime.hour * 60 + nowTime.minute;
    final doseInMinutes = doseTime.hour * 60 + doseTime.minute;
    final diff = doseInMinutes - nowInMinutes;

    setState(() {
      isDelayed = diff < 0;
    });

    if (diff < 0 && !hasNotified) {
      hasNotified = true; // ya notificamos
      showDelayedNotification();
    }

    if (diff == 0) {
      return "Es hora de tu dosis";
    } else if (diff > 0) {
      return "Faltan ${diff ~/ 60}h ${diff % 60}m para tu dosis";
    } else {
      return "Te retrasaste ${-diff ~/ 60}h ${-diff % 60}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    final String doseTime = registerData.first['time'];
    final String doseValue = registerData.first['value'];
    final String message = getDoseMessage(doseTime);

    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in registerData) {
      final DateTime date = item['date'] ?? DateTime.now();

      final String key = _getRelativeDateLabel(date); // Hoy, Ayer, etc.
      if (!groupedData.containsKey(key)) {
        groupedData[key] = [];
      }
      groupedData[key]!.add(item);
    }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Próxima dosis",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "4 mg",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "09:00",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Column(
                            children: [
                              Text(
                                "Mañana",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "09:00",
                                style: TextStyle(
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
              AnimatedSlide(
                offset: const Offset(0, 0.1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: 1.0,
                  child: Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDelayed
                                ? Colors.red.shade300
                                : const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Es hora de tu dosis",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDelayed ? Colors.white : Colors.brown,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDelayed ? Colors.white : Colors.brown,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Error',
                                      message:
                                          'No se pudo registrar la toma. Intenta de nuevo.',
                                      contentType: ContentType.failure,
                                    ),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    isDelayed ? Colors.red : Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text("Confirmar toma"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
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
                              children: const [
                                Text(
                                  'Registro de tomas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            const SizedBox(height: 12),
                            ...groupedData.entries.map((entry) {
                              final label = entry.key;
                              final items = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...items.map((item) {
                                    final bool isTaken =
                                        (item['taken'] ?? false) as bool;
                                    final bgColor =
                                        isTaken
                                            ? const Color(0xFFE7F8EB)
                                            : const Color.fromARGB(
                                              255,
                                              255,
                                              230,
                                              225,
                                            );
                                    final icon =
                                        isTaken
                                            ? Icons.check
                                            : Icons.access_time;
                                    final iconColor =
                                        isTaken
                                            ? Colors.green
                                            : Colors.redAccent;
                                    final timeColor =
                                        isTaken
                                            ? Colors.green
                                            : Colors.redAccent;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              icon,
                                              color: iconColor,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['value'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  item['period'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            item['time'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: timeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showDelayedNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'dose_channel',
      'Dosis Retrasada',
      channelDescription: 'Te notifica si olvidaste tu dosis',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '¡Dosis retrasada!',
      'Ya pasó la hora de tomar tu medicamento',
      notificationDetails,
    );
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

String _getRelativeDateLabel(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) return "Hoy";
  if (difference == 1) return "Ayer";
  if (difference == 2) return "Antier";
  return "${date.day}/${date.month}/${date.year}";
}
