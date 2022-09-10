import 'package:onestop_dev/pages/quick_links/academic_calendar.dart';
import 'package:onestop_dev/pages/quick_links/academic_sso.dart';
import 'package:onestop_dev/pages/quick_links/blogs_page.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/quick_links/complaints.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/barcode.dart';
import 'package:onestop_dev/pages/splash.dart';

final routes = {
  SplashPage.id: (context) => const SplashPage(),
  QRPage.id: (context) => const QRPage(),
  LoginPage.id: (context) => const LoginPage(),
  HomePage.id: (context) => const HomePage(),
  RouterPage.id: (context) => const RouterPage(),
  Blogs.id: (context) => const Blogs(),
  SearchPage.id: (context) => const SearchPage(),
  LostFoundHome.id: (context) => const LostFoundHome(),
  ContactPage.id: (context) => const ContactPage(),
  BuySellHome.id: (context) => const BuySellHome(),
  AcademicSSO.id: (context) => const AcademicSSO(),
  AcademicCalendar.id: (context) => const AcademicCalendar(),
  Complaints.id: (context) => const Complaints(),
};
