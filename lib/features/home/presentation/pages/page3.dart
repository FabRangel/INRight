import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/chartCard.dart';
import 'package:inright/features/home/presentation/widgets/infoCard.dart';
import 'package:inright/features/home/presentation/widgets/nextInrCard.dart';
import 'package:inright/features/home/presentation/widgets/quickActions.dart';
import 'package:inright/features/home/presentation/widgets/sidebar.dart'; // Importa el Sidebar
import 'package:inright/features/home/presentation/widgets/appBarWelcome.dart';
import 'package:inright/features/home/presentation/widgets/dataBox.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      drawer: const Sidebar(),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.45,
            padding: EdgeInsets.only(top: topPadding),
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
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBarWelcome(),
                  const SizedBox(height: 15),
                  dataBox(),
                ],
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.40,
            left: 20,
            right: 20,
            child: QuickActionsWidget(),
          ),

          Positioned(
            top: screenHeight * 0.62,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoCard(),
                      const SizedBox(width: 10),
                      ChartCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: screenHeight * 0.85,
            left: 0,
            right: 0,
            child: NextINRCardWidget(),
          ),
        ],
      ),
    );
  }
}
