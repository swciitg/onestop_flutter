import 'package:flutter/material.dart';

class BottomNavItem {
  final String name;
  final IconData selectedIcon;
  final IconData unselectedIcon;

  const BottomNavItem({
    required this.name,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}
