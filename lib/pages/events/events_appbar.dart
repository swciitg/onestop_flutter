import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/pages/events/events_screen.dart';
import 'package:onestop_dev/pages/events/events_screen_admin.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/stores/event_store.dart';

import '../../models/event_scheduler/admin_model.dart';

class EventsScreenWrapper extends StatefulWidget {

  const EventsScreenWrapper({super.key});

  @override
  State<EventsScreenWrapper> createState() => _EventsScreenWrapperState();
}

class _EventsScreenWrapperState extends State<EventsScreenWrapper> {

  bool isAdmin=false; // Nullable to handle async check

  @override
  void initState() {
    super.initState();
    _checkIfUserIsAdmin();
  }

  Future<void> _checkIfUserIsAdmin() async {
    // Fetch admins and check if the user is an admin
    bool result = await _checkIfUserIsAdminLogic();
    setState(() {
      isAdmin = result;
    });
  }

  Future<bool> _checkIfUserIsAdminLogic() async {
    try {
      final email = LoginStore.userData['outlookEmail'];
      final admin = await APIService().getAdmins();
      if(admin == null) return false;
      bool isAdmin = admin.getUserClubs(email).isNotEmpty;
      return isAdmin;
    } catch (e) {
      log("Error checking admin status: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsStore = Provider.of<EventsStore>(context);

    return Observer(
      builder: (_) => Scaffold(
        appBar: CustomAppBar(
          title: 'Events',
          onBackPressed: () => Navigator.of(context).pop(),
          onViewToggled: eventsStore.toggleAdminView,
          isAdminView: eventsStore.isAdminView, isAdmin: isAdmin,
        ),
        body: eventsStore.isAdminView ? EventsScreen1() : EventsScreen(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;
  final VoidCallback onViewToggled;
  final bool isAdminView;
  final bool isAdmin;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.onViewToggled,
    required this.isAdminView, required this.isAdmin,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF273141),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
          top: Radius.circular(20),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Color.fromARGB(255, 110, 170, 219),
                fontFamily: 'Montserrat'),
          ),
          const Text(
            '.',
            style: TextStyle(
                color: Colors.yellow,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        if(isAdmin)
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          color: const Color(0xFF3E4758),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: isAdminView ? "user" : "admin",
              child: Text(
                isAdminView ? "Switch to User View" : "Switch to Admin View",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
          onSelected: (_) => onViewToggled(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
