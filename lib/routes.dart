import 'package:onestop_dev/pages/academic_calendar.dart';
import 'package:onestop_dev/pages/academic_sso.dart';
import 'package:onestop_dev/pages/blogs_page.dart';
import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/complaints.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/qr.dart';
import 'package:onestop_dev/pages/splash.dart';

final routes = {
  SplashPage.id: (context) => const SplashPage(),
  QRPage.id: (context) => const QRPage(),
  LoginPage.id: (context) => const LoginPage(),
  HomePage.id: (context) => const HomePage(),
  RouterPage.id: (context) => RouterPage(),
  Blogs.id: (context) => const Blogs(),
  SearchPage.id: (context) => const SearchPage(),
  LostFoundHome.id: (context) => LostFoundHome(),
  ContactPage.id: (context) => ContactPage(),
  BuySellHome.id: (context) => BuySellHome(),
  AcademicSSO.id: (context) => AcademicSSO(),
  AcademicCalendar.id: (context) => AcademicCalendar(),
  Complaints.id: (context) => Complaints(),
};
