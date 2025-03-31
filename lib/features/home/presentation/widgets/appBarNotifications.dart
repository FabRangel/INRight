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
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF7F7F9), // Color #F7F7F9
            ),
            child: const Center(
              child: Text(
                "<",
                style: TextStyle(
                  color: Colors.black, // Color del ícono
                  fontSize: 18,
                ),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configuración",
                style: TextStyle(
                  color: Colors.white, // Color del texto
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Espacio entre los textos
              const Text(
                "Personaliza tu experiencia",
                style: TextStyle(
                  color: Colors.white, // Color del texto
                  fontSize: 16,
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
