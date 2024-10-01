import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../../../models/medicalcontacts/medicalcontact_model.dart';
import '../../../../services/data_provider.dart';
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
    medicalContacts=DataProvider.getDropDownContacts();
  }

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String patientEmail = userData['outlookEmail'];
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
                        !LoginStore.isGuest ? Text(
                          "Filling this form as $patientEmail",
                          style: MyFonts.w500.size(11).setColor(kGrey10),
                        ) : SizedBox(height: 0,), 
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Fill this One stop form to submit Pharmacy Feedback directly to the respective authorities.",
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
                          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                          child: Text(
                            "Doctor's Name",
                            style: OnestopFonts.w600.size(16).setColor(kWhite),
                          ),
                        ),
                        FutureBuilder(
                          future: medicalContacts,
                          builder: (BuildContext context, AsyncSnapshot<List<DropdownContactModel>> snapshot) {
                            if(snapshot.hasData) {
                              List<DropdownContactModel> doctors = snapshot.data as List<DropdownContactModel>;

                              doctors.sort((a, b) => a.name.compareTo(b.name)); // Sort by name

                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kGrey2),
                                    color: kBackground,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: DropdownButtonFormField<DropdownContactModel>(
                                      value: selectedDoctor,
                                      items: doctors.map((DropdownContactModel doctor) {
                                        return DropdownMenuItem<DropdownContactModel>(
                                          value: doctor,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doctor.name, // Display the doctor's name
                                                style: OnestopFonts.w500.size(16).setColor(kWhite),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                doctor.designation, // Display doctor's designation or other data
                                                style: OnestopFonts.w400.size(12).setColor(kGrey8),
                                              ),
                                              SizedBox(height:8),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      selectedItemBuilder: (BuildContext context) {
                                        return doctors.map<Widget>((DropdownContactModel doctor) {
                                          return Text(
                                            doctor.name,
                                            style: OnestopFonts.w500.size(16).setColor(kWhite),
                                          );
                                        }).toList();
                                      },
                                      onChanged: (DropdownContactModel? newValue) {
                                        setState(() {
                                          selectedDoctor = newValue; // Set selected doctor
                                        });
                                      },
                                      validator: (val) {
                                        if (val == null) {
                                          return "Select any Doctor name to proceed";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        errorStyle: OnestopFonts.w400,
                                        border: InputBorder.none,
                                        hintText: 'Select Doctor',
                                        hintStyle: const TextStyle(color: kGrey8),
                                      ),
                                      dropdownColor: kBackground, // Dropdown background color
                                      icon: Icon(Icons.arrow_drop_down, color: kWhite),
                                      isExpanded: true,
                                      elevation: 16,
                                      style: OnestopFonts.w500.size(16).setColor(kWhite),
                                      menuMaxHeight: 250,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),



                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, bottom: 10),
                          child: Text(
                            "Brief Description about your feedback or suggestions.",
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
                                      borderRadius:
                                      BorderRadius.circular(24)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextFormField(
                                    maxLines: 4,
                                    controller: remarks,
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
                            ? UploadButton(callBack: (fName) {
                          if (fName != null) files.add(fName);
                          setState(() {});
                        }, endpoint: Endpoints.doctorFileUpload,)
                        : Container(),
                        const SizedBox(height: 24,),
                        GestureDetector(
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (!submitted) {
                              DateTime date = DateTime(selecteddate!.year,
                                  selecteddate!.month, selecteddate!.day);
                              setState(() {
                                submitted = true;
                              });
                              Map<String, dynamic> data = {};
                              data['files'] = files;
                              data['doctor_name'] = selectedDoctor!.name;
                              data['patient_name'] = userData['name']??"";
                              data['mobile_number'] = userData['phoneNumber'].toString();
                              data['remarks'] = remarks.text;
                              data['email'] = patientEmail;
                              data['date']=selecteddate.toString();
                              print(data);
                            try {
                                      var response =
                                          await APIService().postDoctorFeedback(data);
                                      if (!mounted) return;
                                      if (response['success']) {
                                        showSnackBar(
                                            "Your Feedback has been successfully sent to respective authorities.");
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
    //doctorName.dispose();
    remarks.dispose();
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
      "Doctors Feedback",
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
