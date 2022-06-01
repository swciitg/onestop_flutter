import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class DateCourse extends StatelessWidget {
  const DateCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                      child: Text('MON',
                          style: MyFonts.medium.size(20).setColor(kWhite))),
                  FittedBox(
                      child: Text(
                        '24',
                        style: MyFonts.extraBold.size(40).setColor(kWhite),
                      ))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(101, 174, 130, 0.16)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 100,
            child: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.green.shade800,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(101, 174, 130, 0.16)),
          ),
        )
      ],
    );
  }
}
