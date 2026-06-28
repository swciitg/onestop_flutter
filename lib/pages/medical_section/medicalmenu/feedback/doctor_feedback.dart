import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';
import 'package:onestop_dev/pages/medical_section/medicalhome.dart';
import 'package:onestop_dev/repository/medical_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_ui/index.dart';

import '../../../../services/data_service.dart';
import '../../../../widgets/upsp/file_tile.dart';
import '../../../../widgets/upsp/upload_button.dart';

class DoctorFeedback extends StatefulWidget {
  const DoctorFeedback({super.key});

  @override
  State<DoctorFeedback> createState() => _DoctorFeedbackState();
}

class _DoctorFeedbackState extends State<DoctorFeedback> {
  List<String> files = [];

  //final TextEditingController doctorName = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  DropdownContactModel? selectedDoctor;
  DateTime? selecteddate;
  late Future<List<DropdownContactModel>> medicalContacts;

  @override
  void initState() {
    super.initState();
    selecteddate = DateTime.now();
    medicalContacts = DataService.getDropDownContacts();
  }

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String patientEmail = userData['outlookEmail'];
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
          'Doctors Feedback',
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
                      "Fill this One stop form to submit Pharmacy Feedback directly to the respective authorities.",
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
                        "Doctor's Name",
                        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      FutureBuilder(
                        future: medicalContacts,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<DropdownContactModel>> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            List<DropdownContactModel> doctors =
                                snapshot.data as List<DropdownContactModel>;
                            doctors.sort((a, b) => a.name!.compareTo(b.name!));

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: OColor.gray200),
                                color: OColor.white,
                                borderRadius: BorderRadius.circular(OCornerRadius.m),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: OSpacing.m,
                                  vertical: OSpacing.xs,
                                ),
                                child: DropdownButtonFormField<DropdownContactModel>(
                                  initialValue: selectedDoctor,
                                  items:
                                      doctors.map((DropdownContactModel doctor) {
                                        return DropdownMenuItem<DropdownContactModel>(
                                          value: doctor,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doctor.name!,
                                                style: OTextStyle.bodyMedium.copyWith(
                                                  color: OColor.gray800,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                doctor.designation!,
                                                style: OTextStyle.bodySmall.copyWith(
                                                  color: OColor.gray500,
                                                ),
                                              ),
                                              const SizedBox(height: OSpacing.xs),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                  selectedItemBuilder: (BuildContext context) {
                                    return doctors.map<Widget>((DropdownContactModel doctor) {
                                      return Text(
                                        doctor.name!,
                                        style: OTextStyle.bodyMedium.copyWith(
                                          color: OColor.gray800,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onChanged: (DropdownContactModel? newValue) {
                                    setState(() {
                                      selectedDoctor = newValue;
                                    });
                                  },
                                  validator: (val) {
                                    if (val == null) {
                                      return "Select any Doctor name to proceed";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: OTextStyle.bodySmall,
                                    border: InputBorder.none,
                                    hintText: 'Select Doctor',
                                    hintStyle: OTextStyle.bodyMedium.copyWith(
                                      color: OColor.gray400,
                                    ),
                                  ),
                                  dropdownColor: OColor.white,
                                  icon: Icon(Icons.arrow_drop_down, color: OColor.gray800),
                                  isExpanded: true,
                                  elevation: 4,
                                  style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                                  menuMaxHeight: 250,
                                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: OSpacing.m),
                      Text(
                        "Brief Description about your feedback or suggestions.",
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
                      const SizedBox(height: OSpacing.m),
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
                          endpoint: Endpoints.doctorFileUpload,
                        ),
                      const SizedBox(height: OSpacing.l),
                      GestureDetector(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (!submitted) {
                            setState(() => submitted = true);
                            Map<String, dynamic> data = {};
                            data['files'] = files;
                            data['doctorName'] = selectedDoctor!.name;
                            data['doctorDegree'] = selectedDoctor!.degree;
                            data['patientEmail'] = userData['outlookEmail'];
                            data['patientName'] = userData['name'] ?? "";
                            data['mobile'] = userData['phoneNumber'].toString();
                            data['patientHostel'] = userData['hostel'];
                            data['remarks'] = remarks.text;
                            data['rollNo'] = userData['rollNo'];
                            try {
                              var response = await MedicalRepository().postDoctorFeedback(data);
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
    //doctorName.dispose();
    remarks.dispose();
    super.dispose();
  }
}
