// ignore_for_file: unused_import

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/profile/feedback.dart';
import 'package:onestop_dev/widgets/profile/hostel_selector.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static String id = "/qr";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                "${context.read<LoginStore>().userData['name']}",
                textAlign: TextAlign.center,
                style: MyFonts.w800.setColor(kWhite).size(20),
              ),
              Text(
                '${context.read<LoginStore>().userData['rollno']}',
                textAlign: TextAlign.center,
                style: MyFonts.w500.setColor(kWhite).size(20),
              ),
              const HostelSelector(),
              const SizedBox(
                height: 26,
              ),
              // Stack(
              //   children: [
              //     Container(
              //       height: 300,
              //       width: double.infinity,
              //       color: kWhite,
              //     ),
              //     Positioned.fill(
              //       child: Align(
              //         alignment: Alignment.center,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 16),
              //           child: BarcodeWidget(
              //             barcode: Barcode.code128(),
              //             data: "${context.read<LoginStore>().userData['rollno']}",
              //             height: 150,
              //             color: kBlack,
              //             backgroundColor: kWhite,
              //             drawText: false,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: Center(
              //     child: Text(
              //       "Library issuing barcode",
              //       textAlign: TextAlign.center,
              //       style: MyFonts.w500.setColor(kWhite).size(18),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      context.read<LoginStore>().logOut(() =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: kAppBarGrey,
                    ),
                    child: Text(
                      'Log Out',
                      style: MyFonts.w500.setColor(kBlue),
                    )),
              ),
              Expanded(
                flex: 20,
                child: Container(),
              ),
              if (!context.read<LoginStore>().isGuestUser)
                TextButton(
                    onPressed: () {
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
                    child: Text(
                      'Want to report a bug or request a new feature?',
                      style: MyFonts.w500.size(13),
                    )),
              Expanded(child: Container())
              // SizedBox(
              //   height: 15,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
