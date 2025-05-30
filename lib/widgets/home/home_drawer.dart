import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../globals/my_colors.dart';
import '../../pages/profile/profile_page.dart';
import '../../stores/login_store.dart';
import '../profile/feedback.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBackground,
            elevation: 0,
            leadingWidth: 0,
            leading: Container(),
            centerTitle: true,
            title: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Onestop",
                style: OnestopFonts.w600.size(23).letterSpace(1.0).setColor(lBlue2),
              ),
              TextSpan(
                text: ".",
                style: OnestopFonts.w500.size(23).setColor(kYellow),
              )
            ])),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 25,
                // ),
                // Center(
                //     child: Stack(alignment: Alignment.bottomRight, children: [
                //   ClipRRect(
                //       borderRadius: BorderRadius.circular(75.0),
                //       child: const Image(
                //         image: ResizeImage(
                //             AssetImage('assets/images/app_launcher_icon.png'),
                //             width: 75,
                //             height: 75),
                //         fit: BoxFit.fitWidth,
                //       )),
                // ])),

                Container(
                  height: 1,
                  color: Colors.white38,
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => ProfilePage(
                                  profileModel: OneStopUser.fromJson(LoginStore.userData),
                                )));
                    scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "View Profile",
                      style: OnestopFonts.w400.size(14).setColor(kWhite),
                    ),
                  ),
                ),
                if (!LoginStore().isGuestUser)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const FeedBack();
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text(
                        "Bug/Feature Request",
                        textAlign: TextAlign.center,
                        style: OnestopFonts.w400.size(14).setColor(kWhite),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    try {
                      await launchURL("https://swc.iitg.ac.in");
                    } catch (e) {
                      log("ERROR launching URL: https://swc.iitg.ac.in");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "About Us",
                      textAlign: TextAlign.center,
                      style: OnestopFonts.w400.size(14).setColor(kWhite),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (buildContext) => const DeveloperPage(),
                //       ),
                //     );
                //     scaffoldKey.currentState!.closeDrawer();
                //   },
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                //     child: Text(
                //       "Team",
                //       style: OnestopFonts.w400.size(14).setColor(kWhite),
                //     ),
                //   ),
                // ),
                Expanded(child: Container()),

                SvgPicture.asset("assets/images/logo.svg"),
                TextButton(
                  child: Text(
                    "Logout",
                    style: OnestopFonts.w400.size(18).setColor(kRed),
                  ),
                  onPressed: () {
                    {
                      LoginStore().logOut(() => Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false));
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ));
  }
}
