import 'package:flutter/material.dart';
import 'home_tab_tile.dart';

List<HomeTabTile> serviceLinks = [
  HomeTabTile(
      label: "IP Settings",
      icon: Icons.computer_outlined,
      routeId: "/ip"
  ),
  HomeTabTile(
    label: "Contacts",
    icon: Icons.contact_mail_outlined,
    routeId: "/contacto",
  ),
  HomeTabTile(
    label: "Lost and Found",
    icon: Icons.find_in_page_outlined,
    routeId: "/lostFoundHome",
  ),
  HomeTabTile(
    label: "Buy and Sell",
    icon: Icons.article_outlined,
    routeId: "/buySellHome",
  ),
];
