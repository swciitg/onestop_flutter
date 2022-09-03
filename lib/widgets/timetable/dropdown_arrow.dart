import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:provider/provider.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({Key? key, this.showArrow = false}) : super(key: key);
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    if (showArrow) {
      return Observer(builder: (context) {
        return Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: () {
                context.read<TimetableStore>().toggleDropDown();
              },
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: kTimetableGreen,
                ),
                child: Icon(
                  (!context.read<TimetableStore>().showDropDown)
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_up_sharp,
                  color: Colors.green.shade800,
                ),
              ),
            ));
      });
    }
    return const SizedBox();
  }
}

