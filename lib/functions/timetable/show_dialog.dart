import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/build_event.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        content: SingleChildScrollView(
            child: Column(
          children: [
            GestureDetector(
              onTap: () {

                Add2Calendar.addEvent2Cal(
                  buildEvent(title: 'Assignment'),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 40,
                      child: ImageIcon(
                        AssetImage('assets/images/pencil.png'),
                        color: Color.fromRGBO(212, 227, 255, 100),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Assignmments',
                      style: MyFonts.w500.size(20).setColor(
                            const Color.fromRGBO(212, 227, 255, 100),
                          ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {

                Add2Calendar.addEvent2Cal(
                  buildEvent(title: 'Exam'),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 40,
                      child: ImageIcon(
                        AssetImage('assets/images/exam.png'),
                        color: Color.fromRGBO(212, 227, 255, 100),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Exam',
                      style: MyFonts.w500.size(20).setColor(
                            const Color.fromRGBO(212, 227, 255, 100),
                          ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      );
    },
  );
}
