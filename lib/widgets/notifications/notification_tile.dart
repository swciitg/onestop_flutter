import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/notifications/notification_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notifModel});

  final NotifsModel notifModel;

  IconData get notificationIcon {
    switch (notifModel.category.toLowerCase()) {
      case "lost":
      case "found":
        return FluentIcons.document_search_24_filled;
      case "buy":
      case "sell":
        return FluentIcons.money_24_filled;
      case "cabSharing":
        return FluentIcons.vehicle_car_24_filled;
      case "announcement":
        return FluentIcons.alert_urgent_24_filled;
      case "irbs":
        return FluentIcons.calendar_edit_16_regular;
      case "swc":
        return FluentIcons.alert_12_filled;
    }
    return FluentIcons.checkbox_1_20_filled;
  }

  @override
  Widget build(BuildContext context) {
    var iconColor = kGreen;
    var titleColor = kWhite;
    var bodyColor = lBlue;
    var tileBg = kTimetableGreen;
    return Container(
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor,
                    ),
                    child: Icon(
                      notificationIcon,
                      color: kAppBarGrey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    notifModel.title!,
                    style: MyFonts.w500.size(15).setColor(titleColor),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    notifModel.body!,
                    style: MyFonts.w400.size(13).setColor(bodyColor),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                DateFormat.MMMMd().format(notifModel.time!),
                style: MyFonts.w400.setColor(bodyColor),
              ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     color: lBlue2,
              //     borderRadius: BorderRadius.circular(25),
              //     // color: kTimetableGreen,
              //     // border: showHighlight
              //     // ? Border.all(color: Colors.blueAccent)
              //     //     : Border.all(color: Colors.transparent),
              //     // )
              //   ),
              //   padding: EdgeInsets.all(5),
              //   // color: lBlue2,
              //   child: Center(child: Text('12 new', style: MyFonts.w600.setColor(kAppBarGrey),)),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
