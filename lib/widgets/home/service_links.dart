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
  final String iconPath;
  final String routeId;
  final bool newBadge;

  HomeServiceTileData({
    required this.label,
    required this.iconPath,
    required this.routeId,
    this.newBadge = false,
  });

  factory HomeServiceTileData.fromMap(Map<String, dynamic> map) {
    return HomeServiceTileData(
      label: map['label'],
      iconPath: map['iconPath'],
      routeId: map['routeId'],
      newBadge: map['newBadge'] ?? false,
    );
  }
}

List<Map<String, dynamic>> serviceLinksData = [
  {"label": "GateLog", "iconPath": "assets/images/gate_log.svg", "routeId": GateLogPage.id},
  {
    "label": "Library Token",
    "iconPath": "assets/images/lib_token.svg",
    "routeId": LibraryTokenScreen.id,
    "newBadge": true,
  },
  {
    "label": "Election",
    "iconPath": "assets/images/election.svg",
    "routeId": ElectionLoginWebView.id,
    "newBadge": true,
  },
  {"label": "Contacts", "iconPath": "assets/images/contacts.svg", "routeId": ContactPage.id},
  {"label": "Cab Sharing", "iconPath": "assets/images/cab_sharing.svg", "routeId": CabShare.id},
  {"label": "SAC Room Booking", "iconPath": "assets/images/irbs.svg", "routeId": IRBSPage.id},
  {"label": "Complaints", "iconPath": "assets/images/complaints.svg", "routeId": ComplaintsPage.id},
  {"label": "Lost and Found", "iconPath": "assets/images/lnf.svg", "routeId": LostFoundHome.id},
  {"label": "Buy and Sell", "iconPath": "assets/images/bns.svg", "routeId": BuySellHome.id},
  {"label": "GC Score Board", "iconPath": "assets/images/gc.svg", "routeId": Scoreboard.id},
  {
    "label": "Medical Section",
    "iconPath": "assets/images/medical.svg",
    "routeId": MedicalSection.id,
    "newBadge": false,
  },
  {"label": "LAN", "iconPath": "assets/images/LAN.svg", "routeId": RouterPage.id},
];
