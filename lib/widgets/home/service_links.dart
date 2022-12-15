import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:onestop_dev/pages/quick_links/cab_share.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';

List<HomeTabTile> serviceLinks = [
  const HomeTabTile(
    label: "LAN",
    icon: FluentIcons.desktop_24_regular,
    routeId: "/ip",
  ),
  const HomeTabTile(
    label: "Contacts",
    icon: FluentIcons.contact_card_group_24_regular,
    routeId: "/contacto",
  ),
  const HomeTabTile(
    label: "Lost and Found",
    icon: FluentIcons.document_search_24_regular,
    routeId: "/lostFoundHome",
  ),
  const HomeTabTile(
    label: "Buy and Sell",
    icon: FluentIcons.money_20_regular,
    routeId: "/buySellHome",
  ),
  HomeTabTile(label: "Cab Sharing", icon: FluentIcons.vehicle_bus_24_regular, routeId: CabShare.id)
];
