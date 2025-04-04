import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inright/features/home/presentation/widgets/animatedRegisterItem.dart';
import 'package:inright/features/home/presentation/widgets/registerItem.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> registerData = [
    {"value": "4 mg", "date": "Mañana", "time": "09:00", "trend": "check"},
    {"value": "4 mg", "date": "Noche", "time": "21:00", "trend": "wait"},
    {"value": "4 mg", "date": "Mañana", "time": "09:00", "trend": "check"},
    {"value": "4 mg", "date": "Mañana", "time": "09:00", "trend": "check"},
    {"value": "4 mg", "date": "Mañana", "time": "09:00", "trend": "check"},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = screenHeight * 0.34;

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
                    children: [
                      const Text(
                        "Próxima dosis",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      const Text(
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
                          SizedBox(width: 40),
                          Column(
                            children: [
                              Text(
                                "Noche",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "21:00",
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    children: [
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
                              children: const [
                                Text(
                                  'Registro de tomas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Ver todo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Text(
                                "Hoy",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ...registerData
                                .sublist(0, 2)
                                .asMap()
                                .entries
                                .map(
                                  (entry) => AnimatedRegisterItem(
                                    index: entry.key,
                                    item: RegisterItem(
                                      value: entry.value['value'],
                                      date: entry.value['date'],
                                      time: entry.value['time'],
                                      trend: entry.value['trend'],
                                    ),
                                  ),
                                )
                                .toList(),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Text(
                                "Ayer",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ...registerData
                                .sublist(2)
                                .asMap()
                                .entries
                                .map(
                                  (entry) => AnimatedRegisterItem(
                                    index: entry.key + 2,
                                    item: RegisterItem(
                                      value: entry.value['value'],
                                      date: entry.value['date'],
                                      time: entry.value['time'],
                                      trend: entry.value['trend'],
                                    ),
                                  ),
                                )
                                .toList(),
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
