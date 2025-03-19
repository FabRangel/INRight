import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/page1.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:inright/features/home/presentation/pages/page3.dart';
import 'package:inright/features/home/presentation/pages/page4.dart';
import 'package:inright/features/home/presentation/pages/page5.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _HomeState();
}

class _HomeState extends State<Navbar> {
  final _pageController = PageController(initialPage: 2);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      const Page1(),
      const Page2(),
      const Page3(),
      const Page4(),
      const Page5(),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.black87),
      // ),
      //drawer: _buildSidebar(), // Sidebar agregado
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: false,
        kBottomRadius: 40.0,
        bottomBarWidth: MediaQuery.of(context).size.width - 10,
        removeMargins: true,
        showShadow: true, // Agregar sombra
        shadowElevation: 20,
        notchColor: Color.fromARGB(255, 98, 175, 198),
        durationInMilliSeconds: 300,
        kIconSize: 20.0,

        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.show_chart, color: Colors.grey.shade600),
            activeItem: _buildActiveIcon(Icons.show_chart),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.water_drop, color: Colors.grey.shade600),
            activeItem: _buildActiveIcon(Icons.water_drop),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: Colors.blueGrey),
            activeItem: _buildActiveIcon(Icons.home_filled),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.medication_sharp,
              color: Colors.grey.shade600,
            ),
            activeItem: _buildActiveIcon(Icons.medication_sharp),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.notifications,
              color: Colors.grey.shade600,
            ),
            activeItem: _buildActiveIcon(Icons.notifications),
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  // Función para generar los ítems del Sidebar
  Widget _buildSidebarItem(IconData icon, String title, int pageIndex) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra el Sidebar
        _pageController.jumpToPage(
          pageIndex,
        ); // Navega a la página correspondiente
      },
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 98, 175, 198)),
      child: Icon(icon, color: Colors.white, size: 25.0),
    );
  }
}
