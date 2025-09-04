import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/pages/services/gc_scoreboard.dart';
import 'package:onestop_dev/pages/services/irbs.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';

List<HomeServiceTile> serviceLinks = [
  const HomeServiceTile(
    label: "Cab Sharing",
    icon: FluentIcons.vehicle_bus_24_regular,
    routeId: CabShare.id,
  ),
  const HomeServiceTile(
    label: 'IRBS',
    icon: FluentIcons.calendar_edit_24_regular,
    routeId: IRBSPage.id,
  ),
  const HomeServiceTile(
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
  const HomeServiceTile(
    label: "GateLog",
    icon: FluentIcons.door_20_regular,
    routeId: GateLogPage.id,
  ),
  const HomeServiceTile(
    label: "Lost and Found",
    icon: FluentIcons.document_search_24_regular,
    routeId: LostFoundHome.id,
  ),
  const HomeServiceTile(
    label: "Buy and Sell",
    icon: FluentIcons.money_24_regular,
    routeId: BuySellHome.id,
  ),
  const HomeServiceTile(
    label: "GC Score Board",
    icon: FluentIcons.trophy_24_regular,
    routeId: Scoreboard.id,
  ),
  const HomeServiceTile(
    label: "Medical Section",
    icon: FluentIcons.doctor_24_regular,
    routeId: MedicalSection.id,
    newBadge: false,
  ),
  const HomeServiceTile(
    label: "Contacts",
    icon: FluentIcons.contact_card_group_24_regular,
    routeId: ContactPage.id,
  ),
  const HomeServiceTile(label: "LAN", icon: FluentIcons.desktop_24_regular, routeId: RouterPage.id),
  // const HomeTabTile(
  //   label: "Events",
  //   icon: FluentIcons.bookmark_24_regular,
  //   routeId: EventsScreenWrapper.id,
  // ),
];
