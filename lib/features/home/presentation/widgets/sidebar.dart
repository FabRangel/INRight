import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 98, 175, 198)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Usuario",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          _buildSidebarItem(context, Icons.show_chart, 'Estadísticas'),
          _buildSidebarItem(context, Icons.water_drop, 'Hidratación'),
          _buildSidebarItem(context, Icons.home_filled, 'Inicio'),
          _buildSidebarItem(context, Icons.medication_sharp, 'Medicinas'),
          _buildSidebarItem(context, Icons.notifications, 'Notificaciones'),
        ],
      ),
    );
  }

  // Función para construir los ítems del Sidebar
  static Widget _buildSidebarItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra el Sidebar
      },
    );
  }
}