import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/elections/election_login.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:lib_token/lib_token.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/pages/services/gc_scoreboard.dart';
import 'package:onestop_dev/pages/services/irbs.dart';

class HomeServiceTileData {
  final String label;
  final IconData icon;
  final String routeId;
  final bool newBadge;

  HomeServiceTileData({
    required this.label,
    required this.icon,
    required this.routeId,
    this.newBadge = false,
  });

  factory HomeServiceTileData.fromMap(Map<String, dynamic> map) {
    return HomeServiceTileData(
      label: map['label'],
      icon: map['icon'],
      routeId: map['routeId'],
      newBadge: map['newBadge'] ?? false,
    );
  }
}

List<Map<String, dynamic>> serviceLinksData = [
  {"label": "GateLog", "icon": FluentIcons.door_20_regular, "routeId": GateLogPage.id},
  {
    "label": "Library Token",
    "icon": FluentIcons.library_16_regular,
    "routeId": LibraryTokenScreen.id,
    "newBadge": true,
  },
  {
    "label": "Election",
    "icon": FluentIcons.person_passkey_24_regular,
    "routeId": ElectionLoginWebView.id,
    "newBadge": true,
  },
  {
    "label": "Contacts",
    "icon": FluentIcons.contact_card_group_24_regular,
    "routeId": ContactPage.id,
  },
  {"label": "Cab Sharing", "icon": FluentIcons.vehicle_bus_24_regular, "routeId": CabShare.id},
  {"label": "IRBS", "icon": FluentIcons.calendar_edit_24_regular, "routeId": IRBSPage.id},
  {"label": "Complaints", "icon": FluentIcons.chat_help_24_regular, "routeId": ComplaintsPage.id},
  {
    "label": "Lost and Found",
    "icon": FluentIcons.document_search_24_regular,
    "routeId": LostFoundHome.id,
  },
  {"label": "Buy and Sell", "icon": FluentIcons.money_24_regular, "routeId": BuySellHome.id},
  {"label": "GC Score Board", "icon": FluentIcons.trophy_24_regular, "routeId": Scoreboard.id},
  {
    "label": "Medical Section",
    "icon": FluentIcons.doctor_24_regular,
    "routeId": MedicalSection.id,
    "newBadge": false,
  },
  {"label": "LAN", "icon": FluentIcons.desktop_24_regular, "routeId": RouterPage.id},
];
