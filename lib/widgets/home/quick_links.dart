import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'home_tab_tile.dart';

List<HomeTabTile> quickLinks = [
  const HomeTabTile(
    label: "Blogs",
    icon: FluentIcons.document_one_page_24_regular,
    routeId: "/blogs",
  ),
  const HomeTabTile(
    label: "Academic SSO",
    icon: FluentIcons.clipboard_text_32_regular,
    routeId: "/academicSSO",
  ),
  const HomeTabTile(
    label: "Complaints",
    icon: FluentIcons.chat_help_24_regular,
    routeId: "/complaints",
  ),
  const HomeTabTile(
    label: "Academic Calendar",
    icon: FluentIcons.calendar_ltr_24_regular,
    routeId: "/academicCalendar",
  ),
];
