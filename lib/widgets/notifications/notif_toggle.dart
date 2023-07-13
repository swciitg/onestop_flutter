
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:onestop_dev/stores/login_store.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class NotifToggle extends StatefulWidget {
  final String text;
  NotifToggle({super.key, required this.text});

  @override
  State<NotifToggle> createState() => _NotifToggleState();
}

class _NotifToggleState extends State<NotifToggle> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text, style: MyFonts.w500.setColor(kWhite),),
          FlutterSwitch(
            toggleSize: 20,
            toggleColor: kWhite,
            inactiveColor: kGrey,
            activeColor: lBlue2,
            height: 32,
            width: 52,
            value: LoginStore.notifData[widget.text]!,
            onToggle: (val) async {
              if(isLoading) {return;}
              isLoading = true;
              await LoginStore.updateNotifPref(widget.text);
              setState((){});
              isLoading = false;
            },
          ),
        ],
      ),
    );
  }
}
