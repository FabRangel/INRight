import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Widget _buildActiveIcon(IconData icon, {bool isCenter = true}) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 98, 175, 198)),
      child: Icon(
        icon,
        color: const Color.fromARGB(255, 255, 255, 255),
        size: 25.0,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(child: Text('Page 1')),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(child: Text('Page 2')),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xF7F7F9),
      child: const Center(child: Text('Page 3')),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(child: Text('Page 4')),
    );
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(child: Text('Page 5')),
    );
  }
}
