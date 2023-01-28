import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/services/service.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'details_upsp.dart';

class Upsp extends StatefulWidget {
  static const  String id = "/UPSP";
  const Upsp({Key? key}) : super(key: key);

  @override
  State<Upsp> createState() => _UpspState();
}

class _UpspState extends State<Upsp> {
  bool checkBox_1 = false;
  bool checkBox_2 = false;
  bool checkBox_3 = false;
  bool checkBox_4 = false;
  bool checkBox_5 = false;
  bool checkBox_6 = false;
  static const IconData upload = IconData(0xe695, fontFamily: 'MaterialIcons');
  List<String> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text(
                "Fill this One stop form to  address your Academic, Technical, Cultural or Welfare problems directly to the respective boards.",
                style: MyFonts.w400.size(14).setColor(kWhite),
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
                  GestureDetector(
                    onTap: () {
                      String? fileName = Service.uploadFile() as String?;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Upload",
                                  style: MyFonts.w600.size(14).setColor(kWhite),
                                ),
                                const Icon(
                                  upload,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                      checkColor: kGrey6,
                      activeColor: lBlue2,
                      // selected: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // Optionally
                        side: const BorderSide(color: kGrey2),
                      ),
                      onChanged: (v) {
                        print("yess");
                      },
                      title: Text(
                        'Maintenance',
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                      checkColor: kGrey6,
                      activeColor: lBlue2,
                      // selected: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // Optionally
                        side: const BorderSide(color: kGrey2),
                      ),
                      onChanged: (v) {
                        print("yess");
                      },
                      title: Text(
                        'Maintenance',
                        style: MyFonts.w600.size(14).setColor(kWhite),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(3.0),
                  //   child: Container(
                  //       margin: const EdgeInsets.symmetric(horizontal: 12),
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: kGrey2),
                  //           color: kBackground,
                  //           borderRadius: BorderRadius.circular(30)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 10),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Theme(
                  //                 data:
                  //                     ThemeData(unselectedWidgetColor: lBlue3),
                  //                 child: Checkbox(
                  //                   checkColor: kBlack,
                  //                   activeColor: lBlue3,
                  //                   overlayColor:
                  //                       MaterialStateProperty.all(lBlue3),
                  //                   value: checkBox_4,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       checkBox_4 = value!;
                  //                     });
                  //                   },
                  //                 )),
                  //             Text(
                  //               "Maintainence",
                  //               style: MyFonts.w600.size(14).setColor(kWhite),
                  //             ),
                  //           ],
                  //         ),
                  //       )),
                  // ),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DetailsUpsp()));
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
    );
  }
}
