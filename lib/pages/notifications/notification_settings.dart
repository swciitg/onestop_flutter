import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool lost = false;
  bool found = false;
  bool cab=false;
  bool announcement =false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        title:  Text('Notification Settings',
        style: MyFonts.w500,
        ),
      ),
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:  8,horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cab Sharing', style: MyFonts.w500.setColor(kWhite),),
                FlutterSwitch(
                  toggleSize: 20,
                    toggleColor: kWhite,
                    inactiveColor: kGrey,
                    activeColor: lBlue2,
                    height: 32,
                    width: 52,
                    value: cab,
                  onToggle: (val) {
                    print("Cab Sharing toggle is changed to $cab");
                      setState(() {
                        cab = val;
                      });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:  8,horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lost', style: MyFonts.w500.setColor(kWhite),),
                FlutterSwitch(
                  toggleSize: 20,
                  toggleColor: kWhite,
                  inactiveColor: kGrey,
                  activeColor: lBlue2,
                  height: 32,
                  width: 52,
                  value: lost,
                  onToggle: (val) {
                    print("Lost toggle is changed to $lost");
                    setState(() {
                      lost = val;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:  8,horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Found', style: MyFonts.w500.setColor(kWhite),),
                FlutterSwitch(
                  toggleSize: 20,
                  toggleColor: kWhite,
                  inactiveColor: kGrey,
                  activeColor: lBlue2,
                  height: 32,
                  width: 52,
                  value: found,
                  onToggle: (val) {
                    print("Found toggle is changed to $found");
                    setState(() {
                      found = val;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:  8,horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('General Announcement', style: MyFonts.w500.setColor(kWhite),),
                FlutterSwitch(
                  toggleSize: 20,
                  toggleColor: kWhite,
                  inactiveColor: kGrey,
                  activeColor: lBlue2,
                  height: 32,
                  width: 52,
                  value: announcement,
                  onToggle: (val) {
                    print("Announcement toggle is changed to $announcement");
                    setState(() {
                      announcement = val;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
