import 'package:flutter/material.dart';
import 'package:foodapp/screens/bottombars/home.dart';
import 'package:foodapp/screens/menu/menu.dart';
import 'package:foodapp/screens/bottombars/notification.dart';
import 'package:foodapp/screens/bottombars/profile.dart';
import 'package:foodapp/widgets/color_extension.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int currentPage = 0;

  final List<Widget> pages = [
    Home(),
    Menu(),
    Notifications(),
    Notifications(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentPage = 0;
          });
        },
        backgroundColor:
            currentPage == 0 ? Tcolor.primary : Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
          Icons.home,
          size: 30,
          color: currentPage == 0 ? Colors.white : Tcolor.primary,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabIcon(1, Icons.menu),
            _buildTabIcon(2, Icons.apps_sharp),
            const SizedBox(width: 40), // Space for FAB
            _buildTabIcon(3, Icons.notifications),
            _buildTabIcon(4, Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIcon(int index, IconData icon) {
    final isActive = currentPage == index;
    return IconButton(
      onPressed: () {
        setState(() {
          currentPage = index;
        });
      },
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            // color: isActive ? Tcolor.primary : Tcolor.secondaryText,
          ),
        ],
      ),
    );
  }
}
