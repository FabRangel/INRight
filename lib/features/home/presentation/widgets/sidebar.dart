import 'package:flutter/material.dart';
import 'package:inright/features/auth/presentation/login_screen.dart';
import 'package:inright/features/home/presentation/widgets/navbar.dart'; // 👈 Importa Navbar

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
          _buildSidebarItem(
            context,
            Icons.medication_outlined,
            'Mis dosis',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Navbar(initialPage: 3),
                  ),
                ),
          ),
          _buildSidebarItem(
            context,
            Icons.water_drop_outlined,
            'Mis INRs',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Navbar(initialPage: 1),
                  ),
                ),
          ),
          _buildSidebarItem(
            context,
            Icons.notifications_active_outlined,
            'Recordatorios',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Navbar(initialPage: 4),
                  ),
                ),
          ),
          _buildSidebarItem(
            context,
            Icons.settings_outlined,
            'Configuraciones',
            onPressed: () => Navigator.pushNamed(context, '/configurations'),
          ),
          const Divider(),
          _buildSidebarItem(
            context,
            Icons.logout,
            'Cerrar sesión',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) =>
                    false, // Elimina todas las rutas anteriores
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildSidebarItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onPressed,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra el Drawer
        if (onPressed != null) {
          onPressed();
        }
      },
    );
  }
}
