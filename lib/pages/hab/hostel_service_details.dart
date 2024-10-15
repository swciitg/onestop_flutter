import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/functions/utility/validator.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/pages/hab/hostel_service.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

const List<String> Infra = [
  'Electrician',
  'Carpenter',
  'Sanitation',
  'Plumbing',
  'Civil (Room panting damage)',
];

const List<String> Services = [
  'Canteen',
  'Mess',
  'Stationary',
  'Juice Center',
];

class HostelServiceDetails extends StatefulWidget {
  final String complaintType;

  const HostelServiceDetails({Key? key, required this.complaintType})
      : super(key: key);

  @override
  State<HostelServiceDetails> createState() => HostelServiceDetailsState();
}

class HostelServiceDetailsState extends State<HostelServiceDetails> {
  List<String> files = [];
  TextEditingController problem = TextEditingController();
  RadioButtonListController servicesController = RadioButtonListController();
  RadioButtonListController InfraController = RadioButtonListController();
  bool submitted = false;
  TextEditingController contact = TextEditingController();
  TextEditingController complaintID = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController roomNo = TextEditingController();
  List<Hostel> hostels = Hostel.values;
  DateTime? selectedDate;
  //final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueGrey,
              onPrimary: kWhite,
              surface: kBlueGrey,
              onSurface: kWhite,
            ),
            dialogBackgroundColor: kBlueGrey,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

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
                    const ProgressBar(blue: 2, grey: 0),
                    Container(
                      color: kBlueGrey,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 15, left: 15),
                        width: double.infinity,
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
                            if (widget.complaintType == "Infra") ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "Complaint ID",
                                  style: OnestopFonts.w600
                                      .size(16)
                                      .setColor(kWhite),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 0, bottom: 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ', // The asterisk in red color
                                        style: OnestopFonts.w600
                                            .size(16)
                                            .copyWith(color: Colors.red),
                                      ),
                                      TextSpan(
                                        text:
                                            'Complaint ID registered on IPM complaint portal', // Rest of the text
                                        style: OnestopFonts.w600
                                            .size(10)
                                            .setColor(kGrey8),
                                      ),
                                    ],
                                  ),
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
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: TextFormField(
                                          controller: complaintID,
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please fill your complaint ID";
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
                                            hintText:
                                                'Complaint ID of complaint on IPM Section',
                                            hintStyle:
                                                const TextStyle(color: kGrey8),
                                          ),
                                        ))),
                              ),
                            ],
                            if (widget.complaintType == "Infra") ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "Complaint Date",
                                  style: MyFonts.w600.size(16).setColor(kWhite),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 0, bottom: 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '* ', // The asterisk in red color
                                        style: OnestopFonts.w600
                                            .size(16)
                                            .copyWith(color: Colors.red),
                                      ),
                                      TextSpan(
                                        text:
                                            'File your complaint 72 hours after registering on the IPM portal.', // Rest of the text
                                        style: OnestopFonts.w600
                                            .size(10)
                                            .setColor(kGrey8),
                                      ),
                                    ],
                                  ),
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
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: TextFormField(
                                      controller: dateController,
                                      readOnly: true,
                                      style: MyFonts.w500
                                          .size(16)
                                          .setColor(kWhite),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Select Date',
                                        hintStyle:
                                            const TextStyle(color: kGrey8),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                              FluentIcons
                                                  .calendar_ltr_24_regular,
                                              color: kWhite),
                                          onPressed: () => _selectDate(context),
                                        ),
                                      ),
                                      onTap: () => _selectDate(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                            if (widget.complaintType == "Infra") ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "On which service would you like to give to feedback or register complaint?",
                                  style: MyFonts.w600.size(16).setColor(kWhite),
                                ),
                              ),
                              RadioButtonList(
                                values: Infra,
                                controller: InfraController,
                              ),
                            ],
                            if (widget.complaintType == "Services") ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Text(
                                  "On which service would you like to give to feedback or register complaint?",
                                  style: MyFonts.w600.size(16).setColor(kWhite),
                                ),
                              ),
                              RadioButtonList(
                                values: Services,
                                controller: servicesController,
                              ),
                            ],
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
                                ? UploadButton2(callBack: (fName) {
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
                                }
                                if (widget.complaintType == "Infra" &&
                                    complaintID.text.isEmpty) {
                                  showSnackBar("Complaint ID cannot be empty");
                                  return;
                                }
                                if (widget.complaintType == "Infra") {
                                  if (selectedDate == null) {
                                    showSnackBar(
                                        "Please select a complaint date");
                                    return;
                                  }
                                  if (InfraController.selectedItem == null) {
                                    showSnackBar(
                                        "Please select an infrastructure service");
                                    return;
                                  }
                                }

                                if (widget.complaintType == "Services" &&
                                    servicesController.selectedItem == null) {
                                  showSnackBar("Please select a service");
                                  return;
                                }

                                if (contact.text.isEmpty ||
                                    contact.text.length < 10) {
                                  showSnackBar(
                                      "Please enter a valid contact number");
                                  return;
                                }

                                if (roomNo.text.isEmpty) {
                                  showSnackBar("Please enter your room number");
                                  return;
                                }

                                if (selectedHostel == Hostel.none) {
                                  showSnackBar("Please select your hostel");
                                  return;
                                }
                                String temp = "";
                                if (widget.complaintType == "Infra") {
                                  temp = InfraController.selectedItem!;
                                } else if (widget.complaintType == "Services") {
                                  temp = servicesController.selectedItem!;
                                } else {
                                  temp = "General";
                                }
                                Map<String, dynamic> data = {
                                  'problem': problem.text,
                                  'files': files,
                                  'services': temp,
                                  'phone': contact.text,
                                  'name': name,
                                  'email': email,
                                  'room_number': roomNo.text,
                                  'hostel': selectedHostel.databaseString,
                                  'complaintID': widget.complaintType == "Infra"
                                      ? complaintID
                                      : null,
                                  'compalintDate':
                                      widget.complaintType == "Infra"
                                          ? selectedDate
                                          : null,
                                };
                                //print(data);
                                /*if (!_formKey.currentState!.validate()) {
                                    return;
                                  }*/
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
                                      Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              ComplaintsPage.id));
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
    );
  }

  @override
  void dispose() {
    problem.dispose();
    servicesController.dispose();
    super.dispose();
  }
}
