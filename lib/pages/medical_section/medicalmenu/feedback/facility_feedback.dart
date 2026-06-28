import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/repository/medical_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_ui/index.dart';

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
    _datecontroller.text = DateFormat(
      'dd-MMM-yyyy',
    ).format(DateTime.parse(DateTime.now().toIso8601String()));
    selecteddate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String patientEmail = userData['outlookEmail'];
    String? hostel = userData['hostel'];
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Hospital Facility Feedback',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              // Info banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                padding: const EdgeInsets.all(OSpacing.m),
                decoration: BoxDecoration(
                  color: OColor.blue100,
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!LoginStore.isGuest)
                      Padding(
                        padding: const EdgeInsets.only(bottom: OSpacing.xs),
                        child: Text(
                          "Filling this form as $patientEmail",
                          style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                        ),
                      ),
                    Text(
                      "Fill this One stop form to submit Hospital Facility Feedback directly to the respective authorities.",
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: OSpacing.m),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please upload any relevant screenshots, videos, or PDF attachments, if available.",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.s),
                      for (int index = 0; index < files.length; index++)
                        FileTile(
                          filename: files[index],
                          onDelete:
                              () => setState(() {
                                files.removeAt(index);
                              }),
                        ),
                      if (files.length < 5)
                        UploadButton(
                          callBack: (fName) {
                            if (fName != null) files.add(fName);
                            setState(() {});
                          },
                          endpoint: Endpoints.facilityFileUpload,
                        ),
                      const SizedBox(height: OSpacing.m),
                      Text(
                        "Remarks, if any",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: OColor.gray200),
                          color: OColor.white,
                          borderRadius: BorderRadius.circular(OCornerRadius.m),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: OSpacing.m,
                            vertical: OSpacing.s,
                          ),
                          child: TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please fill the required details";
                              }
                              return null;
                            },
                            maxLines: 4,
                            controller: remarks,
                            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Your answer',
                              hintStyle: OTextStyle.bodyMedium.copyWith(color: OColor.gray400),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: OSpacing.l),
                      GestureDetector(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (!submitted) {
                            setState(() => submitted = true);
                            Map<String, dynamic> data = {};
                            data['files'] = files;
                            data['userName'] = patientName.text;
                            data['mobile'] = mobilenumber.text;
                            data['remarks'] = remarks.text;
                            data['userEmail'] = patientEmail;
                            data['userHostel'] = hostel;
                            data['rollNo'] = userData['rollNo'];
                            try {
                              var response = await MedicalRepository().postFacilityFeedback(data);
                              if (!mounted) return;
                              if (response['success']) {
                                showSnackBar(
                                  "Your Feedback has been successfully sent to respective authorities.",
                                );
                                Navigator.popUntil(context, ModalRoute.withName(MedicalSection.id));
                              } else {
                                showSnackBar("Some error occurred. Try again later");
                                setState(() => submitted = false);
                              }
                            } catch (err) {
                              showSnackBar("Please check you internet connection and try again");
                              setState(() => submitted = false);
                            }
                          }
                        },
                        child: const NextButton(title: "Submit"),
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
    patientName.dispose();
    mobilenumber.dispose();
    remarks.dispose();
    _datecontroller.dispose();
    super.dispose();
  }
}
