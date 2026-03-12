import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/profile/profile_tab.dart';
import 'package:onestop_ui/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: OColor.green100,
            child: IconButton(
              icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.green600),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: OText(
          text: 'Profile',
          style: OTextStyle.headingLarge.copyWith(
            color: OColor.gray800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const ProfileTab(),
    );
  }
}
