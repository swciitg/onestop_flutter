import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:onestop_dev/pages/quick_links/academic_calendar.dart';
import 'package:onestop_dev/pages/quick_links/academic_sso.dart';
import 'package:onestop_dev/pages/quick_links/complaints.dart';
import 'package:onestop_dev/pages/quick_links/news_page.dart';

import 'home_tab_tile.dart';

List<HomeTabTile> quickLinks = [
  const HomeTabTile(
    label: "News and Updates",
    icon: FluentIcons.document_one_page_24_regular,
    routeId: NewsPage.id,
  ),
  const HomeTabTile(
    label: "Academic SSO",
    icon: FluentIcons.clipboard_text_32_regular,
    routeId: AcademicSSO.id,
  ),
  const HomeTabTile(
    label: "Complaints",
    icon: FluentIcons.chat_help_24_regular,
    routeId: Complaints.id,
  ),
  const HomeTabTile(
    label: "Academic Calendar",
    icon: FluentIcons.calendar_ltr_24_regular,
    routeId: AcademicCalendar.id,
  )
];
