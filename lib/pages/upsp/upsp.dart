import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:provider/provider.dart';
import 'details_upsp.dart';

const List<String> boards = [
  'Sports Board',
  'Hostel Affairs Board (HAB)',
  'Technical Board',
  'Cultural Board',
  'Welfare Board',
  'Student Alumni Interaction Linkage (SAIL) ',
  'Students Web Committee (SWC)',
  'Students Academic Board (SAB)',
  'Others',
];

const List<String> subcommittees = [
  'Maintainence',
  'Services',
  'Finance',
  'Academic',
  'Rights and Responsibilities',
  'RTI (Right to Information)',
  'Medical related issues'
];

class Upsp extends StatefulWidget {
  static const String id = "/upsp";
  const Upsp({Key? key}) : super(key: key);

  @override
  State<Upsp> createState() => _UpspState();
}

class _UpspState extends State<Upsp> {
  List<String> files = [];
  TextEditingController problem = TextEditingController();
  CheckBoxListController subcommitteeController = CheckBoxListController();
  CheckBoxListController boardsController = CheckBoxListController();

  @override
  Widget build(BuildContext context) {
    var userStore = context.read<LoginStore>();
    var userData = userStore.userData;
    String email = userData['email']!;

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
            "1. Problem",
            style: MyFonts.w600.size(16).setColor(kWhite),
          ),
        ),
        body: userStore.isGuestUser
            ? Center(
                child: Text(
                'Please sign in to use this feature',
                style: MyFonts.w400.size(14).setColor(kWhite),
              ))
            : GestureDetector(
          onTap: (){
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
                              "Fill this One stop form to  address your Academic, Technical, Cultural or Welfare problems directly to the respective boards.",
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
                                "Upload any related screenshot/video/pdf attachment proof",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            for (int index = 0; index < files.length; index++)
                              FileTile(
                                  filename: files[index],
                                  onDelete: () => setState(() {
                                        files.removeAt(index);
                                      })),
                            files.length < 5
                                ? UploadButton(callBack: (fName) {
                                    if (fName != null) files.add(fName);
                                    setState(() {});
                                  })
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Brief Description of your Problem",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  height: 120,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kGrey2),
                                      color: kBackground,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: TextFormField(
                                        maxLines: 4,
                                        controller: problem,
                                        style: MyFonts.w500
                                            .size(16)
                                            .setColor(kWhite),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Your answer',
                                          hintStyle: TextStyle(color: kGrey8),
                                        ),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Respective Board dealing with the grievance raised",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            CheckBoxList(
                              values: boards,
                              controller: boardsController,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Respective Subcommittee dealing with the grievance raised",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            CheckBoxList(
                              values: subcommittees,
                              controller: subcommitteeController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (problem.value.text.isEmpty) {
                                  showSnackBar(
                                      "Problem description cannot be empty");
                                } else {
                                  Map<String, dynamic> data = {
                                    'problem': problem.text,
                                    'files': files,
                                    'boards': boardsController.selectedItems,
                                    'subcommittees':
                                        subcommitteeController.selectedItems
                                  };

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsUpsp(
                                            data: data,
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
    problem.dispose();
    subcommitteeController.dispose();
    boardsController.dispose();
    super.dispose();
  }
}
