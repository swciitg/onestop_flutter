import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/gmis.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/contacts/medical_contacts.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/feedback/medical_feedback.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/medical_insurance.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/medical_reimbursement.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/medical_timetable.dart';
import 'package:onestop_dev/widgets/medicalsection/menuoption.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../functions/utility/show_snackbar.dart';

class MedicalSection extends StatelessWidget {
  static const id = "/medicalsection";

  MedicalSection({super.key});

  final ruleslink = "https://www.iitg.ac.in/medical/Medical%20Rules.pdf";

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
          'Medical Section',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Quick Actions Section
              Text(
                'Quick Actions',
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Doctors Timetable',
                navigationwidget: const MedicalTimetable(),
                icon: FluentIcons.calendar_clock_24_regular,
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Feedback',
                navigationwidget: MedicalFeedback(),
                icon: FluentIcons.chat_24_regular,
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Contacts',
                navigationwidget: const MedicalContacts(),
                icon: FluentIcons.call_24_regular,
              ),

              const SizedBox(height: 24),

              // Insurance & Documents Section
              Text(
                'Insurance & Documents',
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Medical Insurance',
                navigationwidget: const MedicalInsurance(),
                icon: FluentIcons.shield_checkmark_24_regular,
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Download GMIS Card',
                navigationwidget: const Gmis(),
                icon: FluentIcons.card_ui_24_regular,
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Medical Reimbursement',
                navigationwidget: const MedicalReimbursement(),
                icon: FluentIcons.receipt_money_24_regular,
              ),
              const SizedBox(height: 12),
              Menuoption(
                name: 'Medical Rules',
                link: ruleslink,
                icon: FluentIcons.document_text_24_regular,
              ),

              const SizedBox(height: 24),

              // Info links at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: OColor.blue100,
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(FluentIcons.info_24_regular, color: OColor.blue500, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Helpful Links',
                          style: OTextStyle.labelMedium.copyWith(color: OColor.blue500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        text: 'For more details: ',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                        children: [
                          TextSpan(
                            text: 'IIT Guwahati Medical',
                            style: OTextStyle.bodySmall.copyWith(
                              color: OColor.blue500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    try {
                                      _launchURL("https://www.iitg.ac.in/medical/");
                                    } catch (e) {
                                      showSnackBar(e.toString());
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        text: 'Complete Timetable: ',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                        children: [
                          TextSpan(
                            text: 'View PDF',
                            style: OTextStyle.bodySmall.copyWith(
                              color: OColor.blue500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    try {
                                      _launchURL(
                                        "https://www.iitg.ac.in/medical/live_timetable.pdf",
                                      );
                                    } catch (e) {
                                      showSnackBar(e.toString());
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Cannot launch URL";
  }
}
