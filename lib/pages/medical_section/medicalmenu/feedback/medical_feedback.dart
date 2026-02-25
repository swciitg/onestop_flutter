import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/doctor_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/facility_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/pharmacy_feedback.dart';
import 'package:onestop_dev/widgets/medicalsection/menuoption.dart';
import 'package:onestop_ui/index.dart';

class MedicalFeedback extends StatelessWidget {
  MedicalFeedback({super.key});

  final List<String> feedbackoptions = [
    "Pharmacy Feedback",
    "Doctors Feedback",
    "Hospital Facilities Feedback",
  ];

  final feedbackwidgets = [
    const PharmacyFeedback(),
    const DoctorFeedback(),
    const FacilityFeedback(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Medical Feedback',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
        child: Center(
          child: ListView.builder(
            itemCount: feedbackoptions.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Menuoption(
                    name: feedbackoptions[index],
                    navigationwidget: feedbackwidgets[index],
                  ),
                  const SizedBox(height: OSpacing.s),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
