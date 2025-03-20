import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/chartCard.dart';
import 'package:inright/features/home/presentation/widgets/infoCard.dart';
import 'package:inright/features/home/presentation/widgets/nextInrCard.dart';
import 'package:inright/features/home/presentation/widgets/quickActions.dart';
import 'package:inright/features/home/presentation/widgets/sidebar.dart';
import 'package:inright/features/home/presentation/widgets/appBarWelcome.dart';
import 'package:inright/features/home/presentation/widgets/dataBox.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 249),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: topPadding,
                    bottom: screenHeight * 0.05,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarWelcome(),
                        SizedBox(height: screenHeight * 0.015),
                        dataBox(),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.39,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                    ),
                    child: QuickActionsWidget(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(child: InfoCard()),
            //       SizedBox(width: screenWidth * 0.025),
            //       Expanded(child: ChartCard()),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: InfoCard(),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.035),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: ChartCard(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0),
            NextINRCardWidget(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
