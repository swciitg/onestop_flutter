import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/elections/election_login.dart';
import 'package:onestop_dev/pages/events_feed/events_appbar.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/pages/services/gc_scoreboard.dart';
import 'package:onestop_dev/pages/services/irbs.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';

List<HomeTabTile> serviceLinks = [
  const HomeTabTile(
    label: "Cab Sharing",
    icon: FluentIcons.vehicle_bus_24_regular,
    routeId: CabShare.id,
  ),
  const HomeTabTile(
    label: 'IRBS',
    icon: FluentIcons.calendar_edit_24_regular,
    routeId: IRBSPage.id,
  ),
  const HomeTabTile(
    label: "Complaints",
    icon: FluentIcons.chat_help_24_regular,
    routeId: ComplaintsPage.id,
  ),
  // const HomeTabTile(
  //   label: "Election Register",
  //   icon: FluentIcons.person_arrow_right_16_regular,
  //   routeId: ElectionLoginWebView.id,
  //   newBadge: true,
  // ),
  const HomeTabTile(label: "GateLog", icon: FluentIcons.door_20_regular, routeId: GateLogPage.id),
  const HomeTabTile(
    label: "Lost and Found",
    icon: FluentIcons.document_search_24_regular,
    routeId: LostFoundHome.id,
  ),
  const HomeTabTile(
    label: "Buy and Sell",
    icon: FluentIcons.money_24_regular,
    routeId: BuySellHome.id,
  ),
  const HomeTabTile(
    label: "GC Score Board",
    icon: FluentIcons.trophy_24_regular,
    routeId: Scoreboard.id,
  ),
  const HomeTabTile(
    label: "Medical Section",
    icon: FluentIcons.doctor_24_regular,
    routeId: MedicalSection.id,
    newBadge: false,
  ),
  const HomeTabTile(
    label: "Contacts",
    icon: FluentIcons.contact_card_group_24_regular,
    routeId: ContactPage.id,
  ),
  const HomeTabTile(label: "LAN", icon: FluentIcons.desktop_24_regular, routeId: RouterPage.id),
  // const HomeTabTile(
  //   label: "Events",
  //   icon: FluentIcons.bookmark_24_regular,
  //   routeId: EventsScreenWrapper.id,
  // ),
];
