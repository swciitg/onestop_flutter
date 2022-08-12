import 'package:flutter/material.dart';
import 'home_tab_tile.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

List<HomeTabTile> quickLinks = [
  HomeTabTile(
    label: "Blogs",
    icon: FluentIcons.document_one_page_24_regular,
    routeId: "/blogs",
  ),
  HomeTabTile(
    label: "Academic SSO",
    icon: FluentIcons.clipboard_text_32_regular,
    routeId: "/academicSSO",
  ),
  HomeTabTile(
    label: "Complaints",
    icon: FluentIcons.chat_help_24_regular,
    routeId: "/complaints",
  ),
  HomeTabTile(
    label: "Academic Calendar",
    icon: FluentIcons.calendar_ltr_24_regular,
    routeId: "/academicCalendar",
  ),
];
