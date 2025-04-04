import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/page1.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:inright/features/home/presentation/pages/page3.dart';
import 'package:inright/features/home/presentation/pages/page4.dart';
import 'package:inright/features/home/presentation/pages/page5.dart';

class Navbar extends StatefulWidget {
  final int initialPage;

  const Navbar({super.key, this.initialPage = 2});

  @override
  State<Navbar> createState() => _HomeState();
}

class _HomeState extends State<Navbar> {
  late final PageController _pageController;
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _controller = NotchBottomBarController(index: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Page1(),
      Page2(),
      Page3(),
      Page4(),
      Page5(),
    ];

    return Scaffold(
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
        bottomBarWidth: MediaQuery.of(context).size.width - 40,
        removeMargins: true,
        showShadow: true,
        shadowElevation: 10,
        notchColor: const Color.fromARGB(255, 114, 193, 224),
        durationInMilliSeconds: 300,
        kIconSize: 24.0,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Transform.translate(
              offset: Offset(-4, 0),
              child: Icon(Icons.show_chart, color: Colors.grey.shade600),
            ),
            activeItem: _buildActiveIcon(Icons.show_chart),
          ),

          BottomBarItem(
            inActiveItem: Icon(Icons.water_drop, color: Colors.grey.shade600),
            activeItem: _buildActiveIcon(Icons.water_drop),
          ),
          BottomBarItem(
            inActiveItem: Center(
              child: Icon(Icons.home_filled, color: Colors.blueGrey),
            ),
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

  Widget _buildSidebarItem(IconData icon, String title, int pageIndex) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _pageController.jumpToPage(pageIndex);
      },
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      alignment: Alignment.center, // Asegura el centrado
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 114, 193, 224),
        shape: BoxShape.circle, // Opcional para mantener simetría
      ),
      child: Icon(icon, color: Colors.white, size: 25.0),
    );
  }
}
