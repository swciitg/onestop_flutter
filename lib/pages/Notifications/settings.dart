import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotifSettings extends StatefulWidget {
  static String id = "notifications-settings";
  const NotifSettings({Key? key}) : super(key: key);

  @override
  State<NotifSettings> createState() => _NotifSettingsState();
}

List<String> Titles = [
  "Food",
  "Lost and Found",
  "TimeTable",
  "Assignment",
  "Ferry",
  "Buses"
];

class _NotifSettingsState extends State<NotifSettings> {
  Map<String,bool> value={
    "Food" : false,
    "Lost and Food":false,
    "TimeTable":false,
    "Assignment":false,
    "Ferry":false,
    "Buses":false
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        leading: Container(),
        leadingWidth: 10,
        title: Text(
          'Settings',
          style: MyFonts.w500,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: Titles.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Titles[index],
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kWhite,
                    letterSpacing: 0.1,
                    height: 1.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                FlutterSwitch(
                  width: 40.0,
                  height: 25.0,
                  toggleSize: 18.0,
                  value: value[Titles[index]]!,
                  onToggle: (val) {
                    setState(() {
                      value[Titles[index]] = val;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
