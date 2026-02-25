import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../functions/utility/show_snackbar.dart';

class MedicalReimbursement extends StatelessWidget {
  const MedicalReimbursement({super.key});

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
          'Medical Reimbursement',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: OSpacing.m),
                // Step 1
                _buildStepCard(
                  number: "1",
                  title: "Fill the Form",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: OSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(left: OSpacing.s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FORM 1",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: OSpacing.xs),
                              child: Text(
                                "Reimbursement Form for OPD Treatment by Institute Doctor.",
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                              ),
                            ),
                            const SizedBox(height: OSpacing.xxs),
                            Text(
                              "FORM 2",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: OSpacing.xs),
                              child: Text(
                                "Reimbursement Form for OPD Treatment referred to Outside Doctor/Consultants of panel hospitals.",
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                              ),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            InkWell(
                              onTap: () {
                                try {
                                  _launchURL("https://www.iitg.ac.in/medical/FORMS.html");
                                } catch (e) {
                                  showSnackBar(e.toString());
                                }
                              },
                              child: Text(
                                "Click here for form",
                                style: OTextStyle.bodySmall.copyWith(color: OColor.blue500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                // Step 2
                _buildStepCard(
                  number: "2",
                  title:
                      "Original bills for consultation fees/registration fees, medicines to be attached.",
                ),
                const SizedBox(height: OSpacing.s),
                // Step 3
                _buildStepCard(
                  number: "3",
                  title: "Proof of referral from institute doctor to be attached.",
                ),
                const SizedBox(height: OSpacing.s),
                // Step 4
                _buildStepCard(
                  number: "4",
                  title: "A copy of the medical record book to be attached.",
                ),
                const SizedBox(height: OSpacing.s),
                // Step 5
                _buildStepCard(
                  number: "5",
                  title: "Proof of bank account (passbook front page/cheque book) to be attached.",
                ),
                const SizedBox(height: OSpacing.s),
                // Step 6
                _buildStepCard(
                  number: "6",
                  title: "Drop it in the box near the reception counter on the ground floor.",
                ),
                const SizedBox(height: OSpacing.l),
                // Info note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(OSpacing.m),
                  decoration: BoxDecoration(
                    color: OColor.blue100,
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, color: OColor.blue500, size: 24),
                          const SizedBox(width: OSpacing.xs),
                          Expanded(
                            child: Text(
                              "For any Hospitalization (not covered under insurance), please submit Form 3",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: OSpacing.s),
                      Text(
                        "Kindly note that the Part B of Form 3 is to be duly signed with seal by the concerned Hospital",
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({required String number, required String title, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OSpacing.m),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number. $title", style: OTextStyle.labelSmall.copyWith(color: OColor.gray800)),
          if (child != null) child,
        ],
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
