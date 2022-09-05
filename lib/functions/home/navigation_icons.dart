import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';

List<Widget> bottomNavIcons() {
  return [
    const NavigationDestination(
      icon: Icon(FluentIcons.home_24_regular),
      label: 'Home',
      selectedIcon: Icon(
        FluentIcons.home_24_filled,
        color: lBlue2,
      ),
    ),
    const NavigationDestination(
      icon: Icon(FluentIcons.food_24_regular),
      label: 'Food',
      selectedIcon: Icon(
        FluentIcons.food_24_filled,
        color: lBlue2,
      ),
    ),
    const NavigationDestination(
      icon: Icon(FluentIcons.vehicle_bus_24_regular),
      label: 'Travel',
      selectedIcon: Icon(
        FluentIcons.vehicle_bus_24_filled,
        color: lBlue2,
      ),
    ),
    const NavigationDestination(
      icon: Icon(FluentIcons.calendar_ltr_24_regular),
      label: 'Timetable',
      selectedIcon: Icon(
        FluentIcons.calendar_ltr_24_filled,
        color: lBlue2,
      ),
    )
  ];
}
