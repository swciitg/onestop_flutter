import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class TimingTile extends StatelessWidget {
  final String time;
  final bool isLeft;
  final IconData icon;

  const TimingTile(
      {Key? key, required this.time, required this.isLeft, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: const BoxDecoration(
          color: kTileBackground,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        textColor: kWhite,
        leading: CircleAvatar(
          backgroundColor: lYellow2,
          radius: 20,
          child: Icon(
            icon,
            color: kAppBarGrey,
          ),
        ),
        title: Text(
          time,
          style: MyFonts.w500.setColor(kWhite),
        ),
        trailing: isLeft
            ? Text(
          'Left',
          style: MyFonts.w500.setColor(kGrey11),
        )
            : const SizedBox(
          height: 0,
          width: 0,
        ),
      ),
    );
  }
}
