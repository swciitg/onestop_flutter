import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class ComplaintsPage extends StatelessWidget {
  static const String id = "/all-complaints";
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Can not launch url";
      }
    }

    showIntranetDialog() async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kBlueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text(
              'Important',
              style: MyFonts.w600.size(24).setColor(kWhite),
            ),
            content: Text(
              'To access this link, you need to be connected to IITG LAN or have VPN configured on your device.',
              style: MyFonts.w500.size(15).setColor(kWhite),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      "Configure VPN",
                      style: MyFonts.w400.size(15).setColor(lBlue4),
                    ),
                    onPressed: () {
                      try {
                        launchURL("https://www.iitg.ac.in/cc/vpn_cnfg");
                      } catch (e) {
                        //print(e);
                        showSnackBar(e.toString());
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Proceed",
                      style: MyFonts.w400.size(15).setColor(lBlue4),
                    ),
                    onPressed: () {
                      try {
                        launchURL('https://intranet.iitg.ac.in/ipm/complaint/');
                      } catch (e) {
                        //print(e);
                        showSnackBar(e.toString());
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    showDialogHere() async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kBlueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text(
              'Important',
              style: MyFonts.w600.size(24).setColor(kWhite),
            ),
            content: Text(
              'To proceed, your account must be registered in the Complaint System. If you haven\'t registered yet, register yourself first!',
              style: MyFonts.w500.size(15).setColor(kWhite),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: Text(
                      "Register",
                      style: MyFonts.w400.size(15).setColor(lBlue4),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showIntranetDialog();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Proceed",
                      style: MyFonts.w400.size(15).setColor(lBlue4),
                    ),
                    onPressed: () {
                      try {
                        launchURL('https://www.iitg.ac.in/ipm/complaint/');
                      } catch (e) {
                        //print(e);
                        showSnackBar(e.toString());
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        iconTheme: const IconThemeData(color: kAppBarGrey),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "Complaints",
          textAlign: TextAlign.left,
          style: MyFonts.w500.size(20).setColor(kWhite),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.clear,
                color: kWhite,
              ))
        ],
      ),
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
                      Text(
                        "Complaint Portal",
                        style: MyFonts.w700.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "For complaints related to electricity, carpentry, plumbing, sanitary and other civil works in hostels and infrastructure complaints in common and dept areas",
                        style: MyFonts.w500.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                          onTap: () {
                            // try {
                            //   launchURL('https://intranet.iitg.ac.in/ipm/complaint/');
                            // } catch (e) {
                            //   //print(e);
                            //   showSnackBar(e.toString());
                            // }
                            showDialogHere();
                          },
                          child: SizedBox(
                            height: 16,
                            child: Text(
                              "Click here",
                              style: MyFonts.w500.setColor(lBlue4).size(14),
                            ),
                          )),
                      const SizedBox(
                        height: 8,
                      )
                    ]),
              ),
              const Divider(
                height: 1,
                color: kTabBar,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "CBS Complaint portal",
                        style: MyFonts.w700.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "For queries related to LAN",
                        style: MyFonts.w500.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                          onTap: () {
                            try {
                              launchURL('https://www.iitg.ac.in/cb/');
                            } catch (e) {
                              //print(e);
                              showSnackBar(e.toString());
                            }
                          },
                          child: SizedBox(
                            height: 16,
                            child: Text(
                              "Click here",
                              style: MyFonts.w500.setColor(lBlue4).size(14),
                            ),
                          )),
                      const SizedBox(
                        height: 8,
                      )
                    ]),
              ),
              const Divider(
                height: 1,
                color: kTabBar,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "UPSP",
                        style: MyFonts.w700.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "For generic problems you want to let the student gymkhana council know",
                        style: MyFonts.w500.setColor(kWhite).size(14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/upsp");
                          },
                          child: SizedBox(
                            height: 16,
                            child: Text(
                              "Click here",
                              style: MyFonts.w500.setColor(lBlue4).size(14),
                            ),
                          )),
                      const SizedBox(
                        height: 8,
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
