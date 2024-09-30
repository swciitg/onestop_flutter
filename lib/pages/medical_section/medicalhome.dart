import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/gmis.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/contacts/medical_contacts.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/medical_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/medical_insurance.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/medical_reimbursement.dart';
import 'package:onestop_dev/pages/medical_section/medical_timetable/medical_timetable.dart';
import 'package:onestop_dev/widgets/medicalsection/menuoption.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MedicalSection extends StatelessWidget {
  static const id = "/medicalsection";

  MedicalSection({Key? key}) : super(key: key);

  final List<String> options = [
    "Available Doctors",
    "Feedback",
    "Medical Insurance",
    "Download GMIS Card",
    "Medical Reimbursement",
    "Contacts",
    "Medical Rules"
  ];

  final ruleslink = "https://www.iitg.ac.in/medical/Medical%20Rules.pdf";

  final constructors = [
    const MedicalTimetable(),
    MedicalFeedback(),
    const MedicalInsurance(),
    const Gmis(),
    const MedicalReimbursement(),
    const MedicalContacts(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 30, 1),
      appBar: AppBar(
        backgroundColor: OneStopColors.backgroundColor,
        centerTitle: true,
        leadingWidth: 100,
        scrolledUnderElevation: 0,
        leading: OneStopBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: AppBarTitle(title: 'Medical Section'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30,),
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              if (index != 6) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Menuoption(
                        name: options[index],
                        navigationwidget: constructors[index]),
                    const SizedBox(height: 30),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Menuoption(name: options[index], link: ruleslink),
                    const SizedBox(height: 30),
                  ],
                );
              }
            },
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
      "Medical Section",
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
