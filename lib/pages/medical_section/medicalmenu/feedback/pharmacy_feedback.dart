import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/profile/custom_date_picker.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

class PharmacyFeedback extends StatefulWidget {
  const PharmacyFeedback({super.key});

  @override
  State<PharmacyFeedback> createState() => _PharmacyFeedbackState();
}

class _PharmacyFeedbackState extends State<PharmacyFeedback> {
  List<String> files = [];
  final TextEditingController patientName = TextEditingController();
  final TextEditingController mobilenumber = TextEditingController();
  final TextEditingController numberofmedicinesPrescribed =
      TextEditingController();
  final TextEditingController numberofmedicinesAvailable =
      TextEditingController();
  final TextEditingController notAvailableInstantly = TextEditingController();
  final TextEditingController notAvailableMedicine24 = TextEditingController();
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
                                  "Patient Name",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
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
                                      controller: patientName,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Please fill the Patient Name";
                                        }
                                        return null;
                                      },
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
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "Contact Number",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
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
                                      controller: mobilenumber,
                                      maxLength: 10,
                                      style: OnestopFonts.w500
                                          .size(16)
                                          .setColor(kWhite),
                                      decoration: InputDecoration(
                                        errorStyle: OnestopFonts.w400,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Enter your contact number',
                                        hintStyle:
                                            const TextStyle(color: kGrey8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "Date of Prescription",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
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
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: selecteddate ??
                                                    DateTime.now(),
                                                firstDate: DateTime(1920),
                                                //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101),
                                                builder: (context, child) =>
                                                    CustomDatePicker(
                                                      child: child,
                                                    ));
                                        if (pickedDate != null) {
                                          if (!mounted) return;
                                          selecteddate = pickedDate;
                                          String formattedDate =
                                              DateFormat('dd-MMM-yyyy')
                                                  .format(pickedDate);
                                          setState(() {
                                            _datecontroller.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                        }
                                      },
                                      controller: _datecontroller,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Please fill the required details";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 10,
                                      style: OnestopFonts.w500
                                          .size(16)
                                          .setColor(kWhite),
                                      decoration: InputDecoration(
                                        errorStyle: OnestopFonts.w400,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Enter your contact number',
                                        hintStyle:
                                            const TextStyle(color: kGrey8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "No of medicine prescribed by the doctor",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
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
                                          return "Please fill the required details";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: numberofmedicinesPrescribed,
                                      maxLength: 10,
                                      style: OnestopFonts.w500
                                          .size(16)
                                          .setColor(kWhite),
                                      decoration: InputDecoration(
                                        errorStyle: OnestopFonts.w400,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Must be a number',
                                        hintStyle:
                                            const TextStyle(color: kGrey8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "No of medicine available at the Pharmacy",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
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
                                          return "Please fill the required details";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: numberofmedicinesAvailable,
                                      maxLength: 10,
                                      style: OnestopFonts.w500
                                          .size(16)
                                          .setColor(kWhite),
                                      decoration: InputDecoration(
                                        errorStyle: OnestopFonts.w400,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Must be a number',
                                        hintStyle:
                                            const TextStyle(color: kGrey8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "No of medicine not available at the Pharmacy at the time of purchase",
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
                                          controller: notAvailableInstantly,
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
                                  "Name of the medicines not made available within 24 hours",
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
                                          controller: notAvailableMedicine24,
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
                                  "Remarks, if any",
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
                              const SizedBox(
                                height: 24,
                              ),
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
                                    data['date'] = date.toIso8601String();
                                    data['patient_name'] = patientName.text;
                                    data['mobile_number'] = mobilenumber.text;
                                    data['no_of_medicines_prescribed'] =
                                        numberofmedicinesPrescribed.text;
                                    data['no_of_medicines_available'] =
                                        numberofmedicinesAvailable.text;
                                    data['not_made_available_medicine'] =
                                        notAvailableMedicine24.text;
                                    data['not_made_available_instantly'] =
                                        notAvailableInstantly.text;
                                    data['remarks'] = remarks.text;
                                    data['email'] = patientEmail;
                                    print(data);
                                    // try {
                                    //   // var response =
                                    //   //     await APIService().postUPSP(data);
                                    //   if (!mounted) return;
                                    //   if (response['success']) {
                                    //     showSnackBar(
                                    //         "Your problem has been successfully sent to respective au1thorities.");
                                    //     Navigator.popUntil(context,
                                    //         ModalRoute.withName(HomePage.id));
                                    //   } else {
                                    //     showSnackBar(
                                    //         "Some error occurred. Try again later");
                                    //     setState(() {
                                    //       submitted = false;
                                    //     });
                                    //   }
                                    // } catch (err) {
                                    //   showSnackBar(
                                    //       "Please check you internet connection and try again");
                                    //   setState(() {
                                    //     submitted = false;
                                    //   });
                                    // }
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
    numberofmedicinesAvailable.dispose();
    numberofmedicinesPrescribed.dispose();
    notAvailableMedicine24.dispose();
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
      "Pharmacy Feedback",
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
