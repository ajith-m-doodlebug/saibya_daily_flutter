import 'package:flutter/material.dart';
import 'package:saibya_daily/Modules/Module_2_Dashboard/UI/dashboard.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/0_Logs/UI/logs.dart';
import 'package:saibya_daily/Utils/colors.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const Logs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.dashboard,
            index: 0,
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            icon: Icons.add_circle_outline,
            index: 1,
            isSelected: _currentIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.onPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}
