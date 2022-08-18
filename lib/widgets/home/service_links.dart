import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'home_tab_tile.dart';

List<HomeTabTile> serviceLinks = [
  HomeTabTile(
    label: "LAN",
    icon: FluentIcons.desktop_24_regular,
    routeId: "/ip",
  ),
  HomeTabTile(
    label: "Contacts",
    icon: FluentIcons.contact_card_group_24_regular,
    routeId: "/contacto",
  ),
  HomeTabTile(
    label: "Lost and Found",
    icon: FluentIcons.document_search_24_regular,
    routeId: "/lostFoundHome",
  ),
  HomeTabTile(
    label: "Buy and Sell",
    icon: FluentIcons.money_20_regular,
    routeId: "/buySellHome",
  ),
];

// HomeTabTile(
//     label: "Intranet Website",
//     icon: FluentIcons.globe_24_regular
//     routeId: "/buySellHome",
//   ),