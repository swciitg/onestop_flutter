import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../functions/utility/show_snackbar.dart';

class MedicalInsurance extends StatelessWidget {
  const MedicalInsurance({super.key});

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
          'Medical Insurance',
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
                // Basic Coverage Card
                Container(
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
                      Text(
                        "1. Basic Coverage:",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      Text.rich(
                        TextSpan(
                          text: " - Every student is automatically covered for ",
                          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                          children: [
                            TextSpan(
                              text: "Rs. 1,00,000/-",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            TextSpan(
                              text: " (Rupees ",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                            ),
                            TextSpan(
                              text: "One lakh ",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            TextSpan(
                              text: "only)",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: OSpacing.xxs),
                      Text.rich(
                        TextSpan(
                          text: "- No separate enrollment is required,",
                          style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                          children: [
                            TextSpan(
                              text: " as this coverage is already included in the semester fees.",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                // Top-up Coverage Card
                Container(
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
                      Text(
                        "2. Top-up Coverage:",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      Text.rich(
                        TextSpan(
                          text: "  - Students have the option to increase their coverage up to ",
                          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                          children: [
                            TextSpan(
                              text: "Rs. 20 Lakhs",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            TextSpan(
                              text: " by paying the additional top-up fees (extra fees).",
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OSpacing.s),
                // How to Enroll Card
                Container(
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
                      Text(
                        "How to Enroll for Top-up Coverage:",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      Text.rich(
                        TextSpan(
                          text: "1. Visit the registration",
                          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                          children: [
                            TextSpan(
                              text: " link",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.blue500),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      try {
                                        _launchURL("https://online.iitg.ac.in/sso");
                                      } catch (e) {
                                        showSnackBar(e.toString());
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: OSpacing.xxs),
                      Text(
                        "2. Log in using your Institute credentials.",
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                      ),
                      const SizedBox(height: OSpacing.xxs),
                      Text(
                        "3. Navigate to the GMIS section and follow the instructions for top-up registration.",
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                      ),
                      const SizedBox(height: OSpacing.xxs),
                      InkWell(
                        onTap: () {
                          try {
                            _launchURL("https://www.iitg.ac.in/medical/GMISagree2024.pdf");
                          } catch (e) {
                            showSnackBar(e.toString());
                          }
                        },
                        child: Text(
                          "More Details",
                          style: OTextStyle.bodySmall.copyWith(color: OColor.blue500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: OSpacing.m),
              ],
            ),
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
