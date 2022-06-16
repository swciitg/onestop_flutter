import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';

List<Widget> bottomNavIcons() {
  return [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      selectedIcon: Icon(
        Icons.home_filled,
        color: lBlue2,
      ),
    ),
    NavigationDestination(
      icon: Icon(Icons.restaurant_outlined),
      label: 'Food',
      selectedIcon: Icon(
        Icons.restaurant_outlined,
        color: lBlue2,
      ),
    ),
    NavigationDestination(
      icon: Icon(Icons.directions_bus_outlined),
      label: 'Travel',
      selectedIcon: Icon(
        Icons.directions_bus,
        color: lBlue2,
      ),
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      label: 'Timetable',
      selectedIcon: Icon(
        Icons.calendar_month,
        color: lBlue2,
      ),
    )
  ];
}
