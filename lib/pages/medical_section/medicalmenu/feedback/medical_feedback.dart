import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/doctor_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/facility_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/pharmacy_feedback.dart';
import 'package:onestop_dev/widgets/medicalsection/menuoption.dart';
import 'package:onestop_kit/onestop_kit.dart';

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
      backgroundColor: const Color.fromRGBO(28, 28, 30, 1),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(
            child: ListView.builder(
              itemCount: feedbackoptions.length,
              itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Menuoption(
                          name: feedbackoptions[index],
                          navigationwidget: feedbackwidgets[index]),
                      const SizedBox(height: 30),
                    ],
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}


AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Medical Feedback",
      textAlign: TextAlign.center,
      style: OnestopFonts.w500.size(20).setColor(kWhite),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.clear,
          color: kWhite,
        ),
      ),
    ],
  );
}
