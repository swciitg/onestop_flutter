import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
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
  MedicalcontactModel? selectedDoctor;
  DateTime? selecteddate;
  late Future<List<List<MedicalcontactModel>>> medicalContacts;

  @override
  void initState() {
    super.initState();
    selecteddate = DateTime.now();
    medicalContacts=DataProvider.getMedicalContacts();
  }

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String patientEmail = userData['outlookEmail'];
    return LoginStore.isGuest
        ? const GuestRestrictAccess()
        : Theme(
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
                        Text(
                          "Filling this form as $patientEmail",
                          style: MyFonts.w500.size(11).setColor(kGrey10),
                        ),
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
                          builder: (BuildContext context, AsyncSnapshot<List<List<MedicalcontactModel>>> snapshot) {
                            if(snapshot.hasData) {
                              List<List<MedicalcontactModel>> medicalContacts = snapshot.data as List<List<MedicalcontactModel>>;
                              List<MedicalcontactModel> doctors = medicalContacts[0];

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
                                    child: DropdownButtonFormField<MedicalcontactModel>(
                                      value: selectedDoctor,
                                      items: doctors.map((MedicalcontactModel doctor) {
                                        return DropdownMenuItem<MedicalcontactModel>(
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
                                        return doctors.map<Widget>((MedicalcontactModel doctor) {
                                          return Text(
                                            doctor.name,
                                            style: OnestopFonts.w500.size(16).setColor(kWhite),
                                          );
                                        }).toList();
                                      },
                                      onChanged: (MedicalcontactModel? newValue) {
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
                              data['date']=selecteddate;
                              data['doctor_email']= selectedDoctor!.email;
                              print(data);
/*                              try {
                                // var response =
                                //     await APIService().postUPSP(data);
                                if (!mounted) return;
                                if (response['success']) {
                     "{             showSnackBar(
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
                              }*/
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
