import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../functions/utility/show_snackbar.dart';
import '../../../globals/my_colors.dart';
import '../../../globals/my_fonts.dart';

class MedicalInsurance extends StatelessWidget {
  const MedicalInsurance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: OneStopColors.backgroundColor,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text("1. Basic Coverage: ", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),),
                          const SizedBox(
                            height: 4,
                          ),
                          Text.rich(
                              TextSpan(text: " - Every student is automatically covered for ",
                                  style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(text:"Rs. 1,00,000/-",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                                    TextSpan(text:"(Rupees ",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                                    TextSpan(text:"One lakh ",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                                    TextSpan(text:"only)",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),)
                                  ])

                          ),
                          //Text(" - Every student is automatically covered for Rs. 1,00,000/- (Rupees One lakh only)",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                          const SizedBox(height: 4,),
                          Text.rich(
                              TextSpan(
                                text: "- No separate enrollment is required,",
                                style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text:" as this coverage is already included in the semester fees.",
                                    style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300)
                                  )
                                ]
                          )),
                          //Text("- No separate enrollment is required, as this coverage is already included in the semester fees.",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 4,),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                  ),
                  const Divider(height: 1, color: kTabBar,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text("2. Top-up Coverage: ", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),),
                          const SizedBox(
                            height: 4,
                          ),
                          Text.rich(
                              TextSpan(
                                  text:"  - Students have the option to increase their coverage up to ",
                                  style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(text:"Rs. 20 Lakhs",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(text:" by paying the additional top-up fees (extra fees).",
                                      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),
                                    )
                                  ]
                              )
                          ),
                          const SizedBox(height: 4,),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                  ),
                  const Divider(height: 1, color: kTabBar,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Text("How to Enroll for Top-up Coverage:", style: MyFonts.w700.setColor(kWhite).size(14),),
                          const SizedBox(height: 7,),
                          Text.rich(
                              TextSpan(
                                  text:"1. Visit the registration",
                                  style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(
                                        text:" link",
                                        style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300,color: Colors.blue),
                                        recognizer: TapGestureRecognizer()..onTap=(){

                                          try {
                                            _launchURL("https://online.iitg.ac.in/sso");
                                          } catch (e) {
                                            showSnackBar(e.toString());
                                          }
                                        }
                                    )
                                  ]
                              )
                          ),
                          //Text("1. Visit the registration link",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                          const SizedBox(height: 4,),
                          Text("2. Log in using your Institute credentials.",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                          const SizedBox(height: 4,),
                          Text("3. Navigate to the GMIS section and follow the instructions for top-up registration.",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                          const SizedBox(height: 4,),
                          InkWell(
                              onTap: (){
                                try {
                                  _launchURL("https://www.iitg.ac.in/medical/GMISagree2024.pdf");
                                } catch (e) {
                                  showSnackBar(e.toString());
                                }
                              },
                              child: Text("More Details",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300,color: Colors.blue),)),


                          //const SizedBox(height: 4,),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                  ),



                ],
              ),
            ),
          )),
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


AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Medical Insurance",
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