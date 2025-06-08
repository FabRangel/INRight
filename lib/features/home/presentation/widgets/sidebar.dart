import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/auth/presentation/login_screen.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/features/configurations/providers/notification_config_provider.dart';
import 'package:inright/features/configurations/providers/profile_config_provider.dart';
import 'package:inright/features/home/presentation/widgets/navbar.dart';
import 'package:inright/features/home/providers/dosesProvider.dart';
import 'package:inright/features/home/providers/user_provider.dart';
import 'package:provider/provider.dart'; // 👈 Importa Navbar

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final photoUrl = userProvider.userProfilePhotoUrl;
    final userName = userProvider.userName;

    final parts = userName.split(' ');
    final displayName =
        parts.length > 1 ? '${parts[0]} ${parts[1][0]}.' : parts[0];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 98, 175, 198),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[100],
                  backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child:
                      photoUrl.isEmpty
                          ? const Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 10),
                Text(
                  '${displayName}', // Muestra solo el primer nombre
                  style: const TextStyle(fontSize: 20, color: Colors.white),
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
            onPressed: () async {
              // Paso 1: cerrar sesión
              await FirebaseAuth.instance.signOut();

              // Paso 2: limpiar el estado de dosis (y otros si tienes)
              // final dosisProvider = Provider.of<DosisProvider>(
              //   context,
              //   listen: false,
              // );
              // dosisProvider.clearDosis();

              Provider.of<UserProvider>(context, listen: false).clearUserData();
              Provider.of<MedicationConfigProvider>(
                context,
                listen: false,
              ).clearConfig();
              Provider.of<NotificationConfigProvider>(
                context,
                listen: false,
              ).clearNotificationConfig();
              Provider.of<ProfileConfigProvider>(
                context,
                listen: false,
              ).clearProfileConfig();
              Provider.of<DosisProvider>(
                context,
                listen: false,
              ).clearDosis(); // si aplica

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );

              // Paso 3: redirigir al login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
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
