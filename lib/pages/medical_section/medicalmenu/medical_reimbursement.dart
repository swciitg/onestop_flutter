import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../functions/utility/show_snackbar.dart';
import '../../../globals/my_colors.dart';
import '../../../globals/my_fonts.dart';

class MedicalReimbursement extends StatelessWidget {
  const MedicalReimbursement({super.key});

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
                          Text("1. Fill the Form", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left:15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("FORM 1",style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w600),),
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Text("Reimbursement Form for OPD Treatment by Institute Doctor.",style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                                ),
                                const SizedBox(height: 4,),
                                Text("FORM 2",style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child: Text("Reimbursement Form for OPD Treatment referred to Outside Doctor/Consultants of panel hospitals. ",style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),),
                                ),
                                const SizedBox(height: 6,),
                                InkWell(
                                    onTap: (){
                                      try{
                                        _launchURL("https://www.iitg.ac.in/medical/FORMS.html");
                                      }catch(e){
                                        showSnackBar(e.toString());
                                      }
                                    },
                                    child: Text("Click here for form",style: MyFonts.w700.setColor(kWhite).size(13).copyWith(fontWeight: FontWeight.w500,color: Colors.blueAccent),))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
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
                          Text("2. Original bills for consultation fees/registration fees, medicines to be attached.", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(
                            height: 14,
                          ),

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
                          Text("3. Proof of referral from institute doctor to be attached.", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(
                            height: 4,
                          ),
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
                          Text("4. A copy of the medical record book to be attached.", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(
                            height: 4,
                          ),
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
                          Text("5. Proof of bank account (passbook front page/cheque book) to be attached.. ", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(
                            height: 4,
                          ),
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
                          Text("6. Drop it in the box near the reception counter on the ground floor.", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500),),
                          const SizedBox(
                            height: 4,
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                  ),
                  const SizedBox(height: 30,),
                  const Divider(),
                  const SizedBox(height: 15,),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Colors.grey,size: 24,),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "For any Hospitalization (not covered under insurance), please submit Form 3",
                          style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w400,color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          //textAlign: BadgePosition.bottomStart(bottom: -8),
                        ),

                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Text(
                      "Kindly note that the Part B of Form 3 is to be duly signed with seal by theconcerned Hospital",
                      style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w400,color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.visible
                  ),
                  const SizedBox(height: 30,),

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
      "Medical Reimbursement",
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