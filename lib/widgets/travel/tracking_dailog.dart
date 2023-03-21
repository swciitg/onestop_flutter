import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class TrackingDailog extends StatefulWidget {
  const TrackingDailog({Key? key}) : super(key: key);

  @override
  State<TrackingDailog> createState() => _TrackingDailogState();
}

class _TrackingDailogState extends State<TrackingDailog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBlueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      // title: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Text(
      //       'Track Bus',
      //       style: MyFonts.w600.size(24).setColor(kWhite),
      //     ),
      //   ],
      // ),
      content:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('To track the bus, go to the following link and enter the credentials given below'),
          SizedBox(
            height: 10,
          ),
          Text('ID: iitghy'),
          Text('Password: iitg_bus'),

        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Track now  ', style: MyFonts.w500.size(14).setColor(kWhite)),
              const Icon(FluentIcons.open_16_filled, color: kWhite, size: 15,)
            ],
          ),
          onTap: () {
            try{
              launchURL('track4.millitrack.com');
            }
            catch(e){
              //print(e);

            }

          },
        ),
      ],
    );
  }
}



