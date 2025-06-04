import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/home/providers/user_provider.dart';

class AppBarWelcome extends StatefulWidget {
  const AppBarWelcome({super.key});

  @override
  State<AppBarWelcome> createState() => _AppBarWelcomeState();
}

class _AppBarWelcomeState extends State<AppBarWelcome> {
  bool _loadingInitiated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mejor lugar para iniciar operaciones que dependen del contexto
    if (!_loadingInitiated) {
      _loadingInitiated = true;
      _maybeLoadUserData();
    }
  }

  Future<void> _maybeLoadUserData() async {
    // Evitamos usar addPostFrameCallback que puede causar problemas
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userName == 'Usuario' || !userProvider.isAuthenticated) {
      await userProvider.loadUserData(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userProvider.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 120,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white30,
                        color: Colors.white70,
                      ),
                    )
                    : Text(
                      "¡Hola, ${userProvider.userName.split(' ').first}!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                const Text(
                  "Tu salud en el rango correcto",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                          userProvider.userProfilePhotoUrl.isNotEmpty
                              ? NetworkImage(userProvider.userProfilePhotoUrl)
                              : null,
                      child:
                          userProvider.userProfilePhotoUrl.isEmpty
                              ? const Icon(
                                Icons.account_circle,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
