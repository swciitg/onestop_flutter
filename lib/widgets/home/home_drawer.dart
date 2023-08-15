import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../models/profile/profile_model.dart';
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
                style: MyFonts.w600.size(23).letterSpace(1.0).setColor(lBlue2),
              ),
              TextSpan(
                text: ".",
                style: MyFonts.w500.size(23).setColor(kYellow),
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
                                  profileModel: ProfileModel.fromJson(
                                      LoginStore.userData),
                                )));
                    scaffoldKey.currentState!.closeDrawer();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "View Profile",
                      style: MyFonts.w400.size(14).setColor(kWhite),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        "Bug/Feature Request",
                        textAlign: TextAlign.center,
                        style: MyFonts.w400.size(14).setColor(kWhite),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    try {
                      await launchURL("swc.iitg.ac.in");
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      "About Us",
                      textAlign: TextAlign.center,
                      style: MyFonts.w400.size(14).setColor(kWhite),
                    ),
                  ),
                ),
                Expanded(child: Container()),

                SvgPicture.asset("assets/images/logo.svg"),
                TextButton(
                  child: Text(
                    "Logout",
                    style: MyFonts.w400.size(18).setColor(kRed),
                  ),
                  onPressed: () {
                    {
                      LoginStore().logOut(() => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false));
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
