import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/medicaltimetable/doctor_model.dart';
import 'package:onestop_ui/index.dart';

class MedicalTimetableTile extends StatelessWidget {
  final DoctorModel doctor;

  const MedicalTimetableTile({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    var tileIcon = FluentIcons.doctor_24_filled;
    String timing = "";
    if (doctor.startTime1 != "") {
      timing = "$timing${doctor.startTime1} - ${doctor.endTime1}";
    }
    if (doctor.startTime2 != "") {
      timing = "$timing     ${doctor.startTime2} - ${doctor.endTime2}";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 85),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OCornerRadius.m),
            color: OColor.white,
            border: Border.all(color: OColor.gray200),
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
                        decoration: BoxDecoration(shape: BoxShape.circle, color: OColor.green100),
                        child: Icon(tileIcon, color: OColor.green600, size: 25),
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
                        "${doctor.doctor.name!}  ${doctor.doctor.degree!}",
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        doctor.doctor.designation!,
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: 4.0),
                      Text(timing, style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600)),
                      const SizedBox(height: 3.0),
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
