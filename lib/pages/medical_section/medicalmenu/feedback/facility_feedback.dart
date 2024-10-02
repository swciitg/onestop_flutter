import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

class FacilityFeedback extends StatefulWidget {
  const FacilityFeedback({super.key});

  @override
  State<FacilityFeedback> createState() => _FacilityFeedbackState();
}

class _FacilityFeedbackState extends State<FacilityFeedback> {
  List<String> files = [];
  final TextEditingController patientName = TextEditingController();
  final TextEditingController mobilenumber = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  DateTime? selecteddate;

  @override
  void initState() {
    super.initState();
    patientName.text = LoginStore.userData['name'] ?? "";
    mobilenumber.text = LoginStore.userData['phoneNumber'].toString();
    _datecontroller.text = DateFormat('dd-MMM-yyyy')
        .format(DateTime.parse(DateTime.now().toIso8601String()));
    selecteddate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String patientEmail = userData['outlookEmail'];
    String? hostel = userData['hostel'];
    return Theme(
      data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
              side: const BorderSide(color: kWhite),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)))),
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
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
                        !LoginStore.isGuest
                            ? Text(
                                "Filling this form as $patientEmail",
                                style: MyFonts.w500.size(11).setColor(kGrey10),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Fill this One stop form to submit Hospital Facility Feedback directly to the respective authorities.",
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
                            "Please upload any relevant screenshots, videos, or PDF attachments, if available.",
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
                            ? UploadButton(
                                callBack: (fName) {
                                  if (fName != null) files.add(fName);
                                  setState(() {});
                                },
                                endpoint: Endpoints.facilityFileUpload,
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, bottom: 10),
                          child: Text(
                            "Remarks, if any",
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
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please fill the required details";
                                      }
                                      return null;
                                    },
                                    maxLines: 4,
                                    controller: remarks,
                                    style:
                                        MyFonts.w500.size(16).setColor(kWhite),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Your answer',
                                      hintStyle: TextStyle(color: kGrey8),
                                    ),
                                  ))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (!submitted) {
                              // DateTime date = DateTime(selecteddate!.year,
                              //     selecteddate!.month, selecteddate!.day);
                              setState(() {
                                submitted = true;
                              });
                              Map<String, dynamic> data = {};
                              data['files'] = files;
                              data['userName'] = patientName.text;
                              data['mobile'] = mobilenumber.text;
                              data['remarks'] = remarks.text;
                              data['userEmail'] = patientEmail;
                              data['userHostel'] = hostel;
                              data['rollNo'] = userData['rollNo'];
                              // print(data);
                              try {
                                var response = await APIService()
                                    .postFacilityFeedback(data);
                                if (!mounted) return;
                                if (response['success']) {
                                  showSnackBar(
                                      "Your Feedback has been successfully sent to respective authorities.");
                                  Navigator.popUntil(context,
                                      ModalRoute.withName(MedicalSection.id));
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
      ),
    );
  }

  @override
  void dispose() {
    patientName.dispose();
    mobilenumber.dispose();
    remarks.dispose();
    _datecontroller.dispose();
    super.dispose();
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Hospital Facility Feedback",
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
