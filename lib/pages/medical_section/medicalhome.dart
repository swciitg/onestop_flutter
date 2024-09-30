import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../functions/utility/show_snackbar.dart';
import '../../globals/my_fonts.dart';

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
                   //Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 30),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,color:Colors.grey),
                          SizedBox(width:3),
                          Text.rich(TextSpan(
                            text: "For more details:",
                            style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),
                            children: [
                              TextSpan(
                                text:" click here",
                                style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.blueAccent,fontSize: 16,decoration: TextDecoration.underline,),
                                recognizer: TapGestureRecognizer()..onTap=(){

                                  try {
                                    _launchURL("https://www.iitg.ac.in/medical/");
                                  } catch (e) {
                                    showSnackBar(e.toString());
                                  }
                                }
                              )
                            ]
                          )),
                        ],
                      ),
                    )
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

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);  // Use Uri.parse to handle the full URL
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Cannot launch URL";
  }
}