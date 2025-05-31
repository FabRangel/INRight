import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/pages/page1.dart';
import 'package:inright/features/home/presentation/pages/page2.dart';
import 'package:inright/features/home/presentation/pages/page3.dart';
import 'package:inright/features/home/presentation/pages/page4.dart';
import 'package:inright/features/home/presentation/pages/page5.dart';
import 'package:inright/features/home/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    _loadUserDataIfNeeded();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleSignOut() async {
    try {
      // Usar UserProvider para gestionar cierre de sesión
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.signOut();

      // Navegar al login después de cerrar sesión
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  Future<void> _loadUserDataIfNeeded() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userName == 'Usuario' || !userProvider.isAuthenticated) {
      await userProvider.loadUserData();
    }
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
        kBottomRadius: 30.0,
        bottomBarWidth: MediaQuery.of(context).size.width,
        removeMargins: true,
        showShadow: true,
        shadowElevation: 5,
        notchColor: const Color.fromARGB(255, 114, 193, 224),
        durationInMilliSeconds: 300,
        kIconSize: 24.0,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(left: 1.5),
                child: Icon(Icons.show_chart, color: Colors.grey.shade600),
              ),
            ),
            activeItem: _buildActiveIcon(Icons.show_chart),
          ),
          BottomBarItem(
            inActiveItem: SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(right: 1),
                child: Icon(Icons.water_drop, color: Colors.grey.shade600),
              ),
            ),
            activeItem: _buildActiveIcon(Icons.water_drop),
          ),
          // Ítem central (normal)
          BottomBarItem(
            inActiveItem: SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.home_filled, color: Colors.blueGrey),
            ),
            activeItem: _buildActiveIcon(Icons.home_filled),
          ),
          BottomBarItem(
            inActiveItem: SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(left: 3), // ← más espacio artificial
                child: Icon(
                  Icons.medication_sharp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            activeItem: _buildActiveIcon(Icons.medication_sharp),
          ),
          BottomBarItem(
            inActiveItem: SizedBox(
              width: 48,
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(right: 4.5), // ← aún más compensación
                child: Icon(Icons.notifications, color: Colors.grey.shade600),
              ),
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
    return SizedBox(
      width: 48, // ancho fijo
      height: 48, // alto fijo
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 114, 193, 224),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24.0), // igual a los otros
      ),
    );
  }
}
