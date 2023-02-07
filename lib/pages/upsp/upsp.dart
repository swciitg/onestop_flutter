import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/api_caller.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:provider/provider.dart';
import 'details_upsp.dart';

List<String> board = [
  'Sports Board',
  'Hostel Affairs Board (HAB)',
  'Technical Board',
  'Cultural Board',
  'Welfare Board',
  'Student Alumni Interaction Linkage (SAIL) ',
  'Students Web Committee (SWC)',
  'Others',
];

List<String> subcommitte = [
  'Maintainence',
  'Services',
  'Finance',
  'Academic',
  'Rights and Responsibilities',
  'RTI (Right to Information)',
  'Medical related issues'
];

class Upsp extends StatefulWidget {
  static const String id = "/UPSP";
  const Upsp({Key? key}) : super(key: key);

  @override
  State<Upsp> createState() => _UpspState();
}

class _UpspState extends State<Upsp> {
  List<bool> boardCheck = List.filled(board.length, false);
  List<bool> committeeCheck = List.filled(subcommitte.length, false);
  List<String> files = [];
  TextEditingController problem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userStore = context.read<LoginStore>();
    if(userStore.isGuestUser)
      {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kBlueGrey,
            title: Text(
              "UPSP",
              style: MyFonts.w500.size(20).setColor(kWhite),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 18,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    FluentIcons.dismiss_24_filled,
                  ))
            ],
          ),
          body: Center(child: Text('Please sign in to use this feature', style: MyFonts.w400.size(14).setColor(kWhite),)),
        );
      }
    var userData = userStore.userData;
    String email = userData['email']!;
    String name = userData['name']!;
    String roll = userData['rollno']!;

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
            "  1. Problem",
            style: MyFonts.w600.size(16).setColor(kWhite),
          ),
        ),
        body: Column(
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
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                      child: Text(
                        "Upload any related screenshot/video/pdf attachment proof",
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      ),
                    ),
                    // ListView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //     itemCount: files.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Padding(
                    //         padding: const EdgeInsets.all(3.0),
                    //         child: Container(
                    //             margin: const EdgeInsets.symmetric(horizontal: 12),
                    //             decoration: BoxDecoration(
                    //                 border: Border.all(color: kGrey2),
                    //                 color: kBlueGrey,
                    //                 borderRadius: BorderRadius.circular(30)),
                    //             child: Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 20, vertical: 10),
                    //               child:  Text(
                    //                 files[index],
                    //                 style: MyFonts.w400.size(16).setColor(kWhite),
                    //               ),
                    //             )),
                    //       );
                    //     }),
                    // for (int index = 0; index < files.length; index++)
                    //   Padding(
                    //     padding: const EdgeInsets.all(3.0),
                    //     child: Container(
                    //         margin: const EdgeInsets.symmetric(horizontal: 12),
                    //         decoration: BoxDecoration(
                    //             border: Border.all(color: kGrey2),
                    //             color: kBlueGrey,
                    //             borderRadius: BorderRadius.circular(30)),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 20, vertical: 10),
                    //           child: Text(
                    //             files[index],
                    //             style: MyFonts.w400.size(16).setColor(kWhite),
                    //           ),
                    //         )),
                    //   ),
                    GestureDetector(
                      onTap: () async {
                        String? fileName = await Service.uploadFile();
                        if (fileName != null) files.add(fileName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: kGrey2),
                                color: kBackground,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upload",
                                    style:
                                        MyFonts.w600.size(14).setColor(kWhite),
                                  ),
                                  const Icon(
                                    FluentIcons.arrow_upload_16_regular,
                                    color: kWhite,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                      child: Text(
                        "Brief Description of your Problem",
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                          height: 120,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(color: kGrey2),
                              color: kBackground,
                              borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextField(
                                controller: problem,
                                style: MyFonts.w500.size(16).setColor(kWhite),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your answer',
                                  hintStyle: TextStyle(color: kGrey8),
                                ),
                              ))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                      child: Text(
                        "Respective Board dealing with the grievance raised",
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      ),
                    ),
                    for (int i = 0; i < board.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: boardCheck[i],
                          checkColor: kGrey6,
                          activeColor: lBlue2,
                          // selected: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24.0), // Optionally
                            side: const BorderSide(color: kGrey2),
                          ),
                          onChanged: (v) {
                            setState(() {
                              boardCheck[i] = !boardCheck[i];
                            });
                          },
                          title: Text(
                            board[i],
                            style: MyFonts.w600.size(14).setColor(kWhite),
                          ),
                        ),
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                      child: Text(
                        "Respective Subcommittee dealing with the grievance raised",
                        style: MyFonts.w600.size(16).setColor(kWhite),
                      ),
                    ),
                    for (int i = 0; i < subcommitte.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: committeeCheck[i],
                          checkColor: kGrey6,
                          activeColor: lBlue2,
                          // selected: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24.0), // Optionally
                            side: const BorderSide(color: kGrey2),
                          ),
                          onChanged: (v) {
                            setState(() {
                              committeeCheck[i] = !committeeCheck[i];
                            });
                          },
                          title: Text(
                            subcommitte[i],
                            style: MyFonts.w600.size(14).setColor(kWhite),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if(problem.text == '')
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Problem description cannot be empty",
                                  style: MyFonts.w500,
                                )));
                          }
                        else{
                          Map<String, dynamic> data = {
                            'problem': problem.text,
                            'files': files,
                            'name': name,
                            'roll_number': roll,
                            'email': email,
                            'boards': [],
                            'subcommittees': []
                          };
                          for (int index = 0;
                          index < boardCheck.length;
                          index++) {
                            if (boardCheck[index]) {
                              data['boards'].add(board[index]);
                            }
                          }
                          for (int index = 0;
                          index < committeeCheck.length;
                          index++) {
                            if (committeeCheck[index]) {
                              data['subcommittees'].add(subcommitte[index]);
                            }
                          }
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
    );
  }
}
