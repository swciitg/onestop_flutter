import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class MedicalDateSlider extends StatefulWidget {
  const MedicalDateSlider({super.key});

  @override
  State<MedicalDateSlider> createState() => _MedicalDateSliderState();
}

class _MedicalDateSliderState extends State<MedicalDateSlider> {
  @override
  Widget build(BuildContext context) {
    MedicalTimetableStore mttStore = context.read<MedicalTimetableStore>();
    mttStore.initialiseMedicalTT();
    return ListView.builder(
      padding: const EdgeInsets.all(OSpacing.xs),
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
          child: GestureDetector(
            onTap: () {
              mttStore.setDate(index);
              mttStore.setDay(mttStore.dates[index].weekday - 1);
            },
            child: FittedBox(
              child: Observer(
                builder: (context) {
                  bool selected = mttStore.selectedDate == index;
                  TextStyle tStyle =
                      selected
                          ? OTextStyle.labelSmall.copyWith(color: OColor.white)
                          : OTextStyle.labelSmall.copyWith(color: OColor.gray600);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selected ? OColor.green600 : Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kday[mttStore.dates[index].weekday]!, style: tStyle),
                          Text(
                            mttStore.dates[index].day.toString(),
                            style: tStyle.copyWith(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
