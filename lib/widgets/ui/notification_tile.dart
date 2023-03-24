
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kTimetableGreen,
        borderRadius: BorderRadius.circular(25),
        // color: kTimetableGreen,
        // border: showHighlight
        // ? Border.all(color: Colors.blueAccent)
        //     : Border.all(color: Colors.transparent),
        // )
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kGreen,
                    ),
                    child: Icon(
                      FluentIcons.vehicle_car_24_filled,
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
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  // Text(
                  //   'Text1',
                  //   style:
                  //       MyFonts.w300.size(12).setColor(kWhite),
                  // ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Cab Sharing',
                    style:
                    MyFonts.w500.size(15).setColor(kWhite),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    'A new reply to your cab sharing post. Check it out now and book together',
                    style:
                    MyFonts.w400.size(13).setColor(lBlue),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lBlue2,
                  borderRadius: BorderRadius.circular(25),
                  // color: kTimetableGreen,
                  // border: showHighlight
                  // ? Border.all(color: Colors.blueAccent)
                  //     : Border.all(color: Colors.transparent),
                  // )
                ),
                padding: EdgeInsets.all(5),
                // color: lBlue2,
                child: Center(child: Text('12 new', style: MyFonts.w600.setColor(kAppBarGrey),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
