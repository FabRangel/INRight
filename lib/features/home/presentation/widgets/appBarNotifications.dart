import 'package:flutter/material.dart';

class AppBarNotifications extends StatefulWidget {
  final Function(int)? onItemTapped; // Callback para notificar cambios

  const AppBarNotifications({super.key, this.onItemTapped});

  @override
  AppBarNotificationsState createState() => AppBarNotificationsState();
}

class AppBarNotificationsState extends State<AppBarNotifications> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Notificar a Page5 sobre el cambio
    widget.onItemTapped?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 36,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Configuración",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Personaliza tu experiencia",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOption(0, "Perfil"),
            _buildOption(1, "Medicación"),
            _buildOption(2, "Notificaciones"),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(int index, String text) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
