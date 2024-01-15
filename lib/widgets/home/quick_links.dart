import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';

import 'home_tab_tile.dart';

List<HomeTabTile> quickLinks = [
  const HomeTabTile(
    label: "Guest House",
    icon: FluentIcons.building_retail_20_regular,
    link: "https://online.iitg.ac.in/sso/",
  ),
  const HomeTabTile(
    label: "Academic SSO",
    icon: FluentIcons.clipboard_text_32_regular,
    link: "https://academic.iitg.ac.in/sso/",
  ),
  const HomeTabTile(
    label: "Academic Calendar",
    icon: FluentIcons.calendar_ltr_24_regular,
    link: "https://iitg.ac.in/acad/academic_calendar.php",
  ),
  const HomeTabTile(
    label: "Placement Stats",
    icon: CupertinoIcons.money_dollar,
    link: "https://swc.iitg.ac.in/placement-stats/",
  )
];
