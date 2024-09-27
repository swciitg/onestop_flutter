import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

const List<String> services = [
  'Canteen',
  'Juice Center',
  'Mess',
  'Stationery',
  'Infra'
];

class HostelService extends StatefulWidget {
  static const String id = "/hostelService";

  const HostelService({Key? key}) : super(key: key);

  @override
  State<HostelService> createState() => HostelServiceState();
}

class HostelServiceState extends State<HostelService> {
  List<String> files = [];
  TextEditingController problem = TextEditingController();
  CheckBoxListController servicesController = CheckBoxListController();
  bool submitted = false;
  TextEditingController contact = TextEditingController();
  TextEditingController roomNo = TextEditingController();
  List<Hostel> hostels = Hostel.values;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String email = userData['outlookEmail']!;
    String name = userData['name']!;
    roomNo.text = userData['roomNo']!.toString();
    Hostel selectedHostel =
        userData['hostel']!.toString().getHostelFromDatabaseString() ??
            Hostel.none;
    contact.text = userData['phoneNumber']!.toString();

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
            "Hostel Complaints",
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
                    //const ProgressBar(blue: 1, grey: 1),
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
                              "One Stop Services Complaint Redressal by HAB",
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
                                "Your Hostel",
                                style:
                                    OnestopFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: kBlueGrey),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: DropdownButtonFormField<Hostel>(
                                  value: selectedHostel,
                                  validator: (val) {
                                    if (val == null || val == Hostel.none) {
                                      return "Hostel can not be empty";
                                    }
                                    return null;
                                  },
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text("Select your hostel",
                                        style: OnestopFonts.w500
                                            .setColor(kGrey8)
                                            .size(16)),
                                  ),
                                  decoration: InputDecoration(
                                    errorStyle: OnestopFonts.w400,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: kGrey8),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: kGrey8),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: kGrey8),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: kGrey8),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  icon: const Icon(
                                    FluentIcons.chevron_down_24_regular,
                                    color: kWhite,
                                  ),
                                  style: OnestopFonts.w600
                                      .size(14)
                                      .setColor(kWhite),
                                  onChanged: (data) {
                                    setState(() {
                                      selectedHostel = data!;
                                    });
                                  },
                                  items: hostels
                                      .map<DropdownMenuItem<Hostel>>((value) {
                                    return DropdownMenuItem<Hostel>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          value.displayString,
                                          style: OnestopFonts.w600
                                              .size(14)
                                              .setColor(kWhite),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Your Room Number",
                                style:
                                    OnestopFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kGrey2),
                                      color: kBackground,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: TextFormField(
                                        controller: roomNo,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "Please fill your room number";
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[A-Z0-9!-]')),
                                        ],
                                        // keyboardType: TextInputType.number,
                                        style: OnestopFonts.w500
                                            .size(16)
                                            .setColor(kWhite),
                                        decoration: InputDecoration(
                                          errorStyle: OnestopFonts.w400,
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: 'Your Answer',
                                          hintStyle:
                                              const TextStyle(color: kGrey8),
                                        ),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "On which service would you like to give to feedback or register complaint?",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            CheckBoxList(
                              values: services,
                              controller: servicesController,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "FEEDBACK",
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  height: 120,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
                                          hintText: 'Enter your answer',
                                          hintStyle: TextStyle(color: kGrey8),
                                        ),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 15, bottom: 10),
                              child: Text(
                                "Contact Number",
                                style:
                                    OnestopFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: kGrey2),
                                      color: kBackground,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: TextFormField(
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return "Please fill your contact number";
                                          }
                                          if (val.length < 10) {
                                            return "Enter a valid contact number";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: contact,
                                        maxLength: 10,
                                        style: OnestopFonts.w500
                                            .size(16)
                                            .setColor(kWhite),
                                        decoration: InputDecoration(
                                          errorStyle: OnestopFonts.w400,
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: 'Your Answer',
                                          hintStyle:
                                              const TextStyle(color: kGrey8),
                                        ),
                                      ))),
                            ),
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
                            const SizedBox(
                              height: 24,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (problem.value.text.isEmpty) {
                                  showSnackBar(
                                      "Problem description cannot be empty");
                                } else {
                                  Map<String, dynamic> data = {
                                    'problem': problem.text,
                                    'files': files,
                                    'boards': servicesController.selectedItems,
                                    'phone': contact.text,
                                    'name': name,
                                    'email': email,
                                    'room_number': roomNo.text,
                                    'hostel': selectedHostel.databaseString,
                                  };

                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (!submitted) {
                                    setState(() {
                                      submitted = true;
                                    });

                                    try {
                                      var response =
                                          await APIService().postHAB(data);
                                      if (!mounted) return;
                                      if (response['success']) {
                                        showSnackBar(
                                            "Your problem has been successfully sent to respective au1thorities.");
                                        Navigator.popUntil(context,
                                            ModalRoute.withName(HomePage.id));
                                      } else {
                                        showSnackBar(
                                            "Some error occurred. Try again later");
                                        setState(() {
                                          submitted = false;
                                        });
                                      }
                                    } catch (err) {
                                      showSnackBar(
                                          "Please check you internet connection and try again");
                                      setState(() {
                                        submitted = false;
                                      });
                                    }
                                  }
                                }
                              },
                              child: const NextButton(
                                title: "Submit",
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
    servicesController.dispose();
    super.dispose();
  }
}
