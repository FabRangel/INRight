import 'package:flutter/material.dart';

class AppBarWelcome extends StatelessWidget {
  const AppBarWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, María!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Bienvenida a tu control INR",
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
                backgroundColor: Colors.white, // Borde blanco
                child: const CircleAvatar(
                  radius: 28,
                  child: Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
