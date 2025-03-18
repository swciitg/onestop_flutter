import 'package:onestop_dev/pages/buy_sell/bns_home.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/elections/election_login.dart';
import 'package:onestop_dev/pages/events_feed/events_appbar.dart';
import 'package:onestop_dev/pages/food/mess_opi_form.dart';
import 'package:onestop_dev/pages/food/mess_subscription_change_form.dart';
import 'package:onestop_dev/pages/food/search_results.dart';
import 'package:onestop_dev/pages/hab/hostel_service.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/ip/ip_carousel.dart';
import 'package:onestop_dev/pages/login/blocked.dart';
import 'package:onestop_dev/pages/login/login.dart';
import 'package:onestop_dev/pages/login/splash.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/pages/notifications/notifications.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/pages/services/gate_log_page.dart';
import 'package:onestop_dev/pages/services/gc_scoreboard.dart';
import 'package:onestop_dev/pages/services/irbs.dart';
import 'package:onestop_dev/pages/upsp/upsp.dart';

final routes = {
  BlockedPage.id: (context) => const BlockedPage(),
  IRBSPage.id: (context) => const IRBSPage(),
  SplashPage.id: (context) => const SplashPage(),
  LoginPage.id: (context) => const LoginPage(),
  HomePage.id: (context) => const HomePage(),
  RouterPage.id: (context) => const RouterPage(),
  SearchPage.id: (context) => const SearchPage(),
  LostFoundHome.id: (context) => const LostFoundHome(),
  ContactPage.id: (context) => const ContactPage(),
  BuySellHome.id: (context) => const BuySellHome(),
  CabShare.id: (context) => const CabShare(),
  NotificationPage.id: (context) => const NotificationPage(),
  Scoreboard.id: (context) => const Scoreboard(),
  Upsp.id: (context) => const Upsp(),
  ComplaintsPage.id: (context) => const ComplaintsPage(),
  MessOpiFormPage.id: (context) => const MessOpiFormPage(),
  MessSubscriptionPage.id: (context) => const MessSubscriptionPage(),
  MedicalSection.id: (context) => MedicalSection(),
  HostelService.id: (context) => const HostelService(),
  ElectionLoginWebView.id: (context) => const ElectionLoginWebView(),
  GateLogPage.id: (context) => const GateLogPage(),
  EventsScreenWrapper.id: (context) => const EventsScreenWrapper(),
};
