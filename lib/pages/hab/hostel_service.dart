import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/hab/hostel_service_details.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_kit/onestop_kit.dart';

const List<String> complaintType = ['Services', 'Infra', 'General'];

class HostelService extends StatefulWidget {
  static const String id = "/hostelService";

  const HostelService({Key? key}) : super(key: key);

  @override
  State<HostelService> createState() => _HostelServiceState();
}

class _HostelServiceState extends State<HostelService> {
  RadioButtonListController complaintTypeController =
      RadioButtonListController();

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String email = userData['outlookEmail']!;

    return Theme(
      data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
              side: const BorderSide(color: kWhite),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)))),
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          title: Text(
            "1. Hostel Services",
            style: MyFonts.w600.size(16).setColor(kWhite),
          ),
        ),
        body: LoginStore.isGuest
            ? Center(
                child: Text(
                'Please sign in to use this feature',
                style: MyFonts.w400.size(14).setColor(kWhite),
              ))
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: [
                    const ProgressBar(blue: 1, grey: 1),
                    Container(
                      color: kBlueGrey,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 10, left: 16, right: 16, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Filling this form as $email",
                              style: MyFonts.w500.size(11).setColor(kGrey10),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Fill this One stop form to  address your Hostel related problems directly to the respective authority",
                              style: MyFonts.w400.size(14).setColor(kWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Which one of the follwing best describes your problem",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            RadioButtonList(
                              values: complaintType,
                              controller: complaintTypeController,
                            ),
                            const Padding(
                                padding:
                                     EdgeInsets.symmetric(vertical: 10)),
                            GestureDetector(
                              onTap: () {
                                if (complaintTypeController.selectedItem ==
                                    null) {
                                  showSnackBar("Selcect an option to proceed");
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          HostelServiceDetails(
                                            complaintType:
                                                complaintTypeController
                                                    .selectedItem!,
                                          )));
                                }
                              },
                              child: const NextButton(
                                title: "Next",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    complaintTypeController.dispose();
    super.dispose();
  }
}
