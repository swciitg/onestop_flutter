import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MedicalTimetableTile extends StatelessWidget {
  final DoctorModel doctor;

  const MedicalTimetableTile({Key? key, required this.doctor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tileIcon = FluentIcons.doctor_24_filled;
    Color bg = kTimetableDisabled;
    String timing = "";
    if (doctor.starttime1 != "") {
      timing = "$timing${doctor.starttime1} - ${doctor.endtime1}";
    }
    if(doctor.starttime2 != ""){
      timing = "$timing     ${doctor.starttime2} - ${doctor.endtime2}";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 85),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: bg,
            border: Border.all(color: Colors.transparent),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kGreen,
                        ),
                        child: Icon(
                          tileIcon,
                          color: kAppBarGrey,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${doctor.name!}  ${doctor.degree!}",
                        style: MyFonts.w500.size(15).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        doctor.designation!,
                        style: MyFonts.w500.size(15).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        timing,
                        style: MyFonts.w300.size(12).setColor(kWhite),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
