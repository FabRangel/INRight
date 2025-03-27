import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/medicationTime.dart';
import 'package:inright/features/home/presentation/widgets/pacientCard.dart';
import 'package:inright/features/home/presentation/widgets/rangeInr.dart';
import 'package:inright/features/home/presentation/widgets/targetRange.dart';
import 'package:inright/features/home/presentation/widgets/sidebar.dart';
import 'package:inright/features/home/presentation/widgets/appBarNotifications.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualizar el estado
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 249),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              width: double.infinity,
              height: screenHeight * 0.4, // Altura del fondo
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
            ),

            // Contenido principal
            Column(
              children: [
                // AppBarNotifications
                Padding(
                  padding: EdgeInsets.only(
                    top: topPadding,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: AppBarNotifications(
                    onItemTapped: _onItemTapped, // Pasar el callback
                  ),
                ),

                // Espacio entre AppBarNotifications y el contenido dinámico
                SizedBox(height: screenHeight * 0.05),

                // Contenido dinámico
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: _buildContent(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el contenido dinámico
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const PacientCardWidget();
      case 1:
        return Column(
          children: [
            const TargetRangeWidget(),
            const SizedBox(height: 20),
            const MedicationTimeWidget(),
            const SizedBox(height: 20),
            const RangeInr(),
            const SizedBox(height: 90),
          ],
        );
      case 2: // Notificaciones
        return const Center(
          child: Text(
            "Contenido de Notificaciones",
            style: TextStyle(color: Colors.white),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
