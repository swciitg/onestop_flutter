import 'package:onestop_dev/pages/notifications/notifications.dart';
import 'package:onestop_dev/pages/quick_links/academic_calendar.dart';
import 'package:onestop_dev/pages/quick_links/academic_sso.dart';
import 'package:onestop_dev/pages/quick_links/cab_share.dart';
import 'package:onestop_dev/pages/quick_links/gc_scoreboard.dart';
import 'package:onestop_dev/pages/quick_links/guest_house.dart';
import 'package:onestop_dev/pages/quick_links/news_page.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/quick_links/complaints.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/profile.dart';
import 'package:onestop_dev/pages/splash.dart';
import 'package:onestop_dev/pages/upsp/upsp.dart';

final routes = {
  SplashPage.id: (context) => const SplashPage(),
  ProfilePage.id: (context) => const ProfilePage(),
  LoginPage.id: (context) => const LoginPage(),
  HomePage.id: (context) => const HomePage(),
  RouterPage.id: (context) => const RouterPage(),
  NewsPage.id: (context) => const NewsPage(),
  SearchPage.id: (context) => const SearchPage(),
  LostFoundHome.id: (context) => const LostFoundHome(),
  ContactPage.id: (context) => const ContactPage(),
  BuySellHome.id: (context) => const BuySellHome(),
  AcademicSSO.id: (context) => const AcademicSSO(),
  AcademicCalendar.id: (context) => const AcademicCalendar(),
  Complaints.id: (context) => const Complaints(),
  CabShare.id: (context) => const CabShare(),
  NotificationPage.id: (context) => const NotificationPage(),
  Scoreboard.id: (context) => const Scoreboard(),
  Upsp.id: (context) => const Upsp(),
  GuestHouse.id: (context) => const GuestHouse(),
};
