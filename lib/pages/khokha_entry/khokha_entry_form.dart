import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/functions/utility/validator.dart';
import 'package:onestop_dev/globals/departments.dart';
import 'package:onestop_dev/globals/prgrams.dart';
import 'package:onestop_dev/globals/hostels.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/models/profile/profile_model.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/profile/custom_dropdown.dart';
import 'package:onestop_dev/widgets/profile/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KhokhaEntryForm extends StatefulWidget {
  static const id = "/khokha_entry_form";
  const KhokhaEntryForm({super.key});

  @override
  State<KhokhaEntryForm> createState() => _KhokhaEntryFormState();
}

class _KhokhaEntryFormState extends State<KhokhaEntryForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String? hostel;
  final List<String> hostels = khostels;
  var program = kprograms.first;
  var department = kdepartments.first;
  var selectedDestination = "Khokha";
  final destinationSuggestions = [
    "Khokha",
    "City",
    "Other",
  ];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    resetForm();
  }

  void resetForm() {
    ProfileModel p = ProfileModel.fromJson(LoginStore.userData);
    _nameController.text = p.name;
    _rollController.text = p.rollNo;
    _phoneController.text = p.phoneNumber == null ? "" : p.phoneNumber.toString();
    _roomNoController.text = p.roomNo ?? "";
    _destinationController.text = "";
    hostel = p.hostel;
    selectedDestination = destinationSuggestions.first;
    setState(() {});
  }

  void showQRImage() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar('Please give all the inputs correctly');
      return;
    }
    final destination =
        selectedDestination == "Other" ? _destinationController.text : selectedDestination;
    final mapData = {
      "name": _nameController.text,
      "roll": _rollController.text,
      "phone": _phoneController.text,
      "room": _roomNoController.text,
      "hostel": hostel,
      "program": program,
      "department": department,
      "destination": destination,
    };
    final data = jsonEncode(mapData);
    final width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    final image = QrImageView(
      data: data,
      version: QrVersions.auto,
      size: width * 0.6,
      gapless: false,
      embeddedImageStyle: const QrEmbeddedImageStyle(
        color: Colors.white,
      ),
      eyeStyle: const QrEyeStyle(
        color: Colors.white,
        eyeShape: QrEyeShape.square,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        color: Colors.white,
        dataModuleShape: QrDataModuleShape.circle,
      ),
    );

    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kAppBarGrey,
          surfaceTintColor: Colors.transparent,
          content: SizedBox(
            width: width * 0.6,
            height: width * 0.6 + 60,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image,
                  const SizedBox(height: 16),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Destination: ',
                          style: MyFonts.w500.setColor(kWhite3).size(14),
                        ),
                        TextSpan(
                          text: destination,
                          style: MyFonts.w500.setColor(lBlue2).size(14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBarGrey,
          iconTheme: const IconThemeData(color: kAppBarGrey),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: kWhite,
            ),
            iconSize: 20,
          ),
          title: Text(
            "Khokha Entry",
            textAlign: TextAlign.left,
            style: MyFonts.w500.size(23).setColor(kWhite),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Fields marked with',
                                    style: MyFonts.w500.setColor(kWhite3).size(12),
                                  ),
                                  TextSpan(
                                    text: ' * ',
                                    style: MyFonts.w500.setColor(kRed).size(12),
                                  ),
                                  TextSpan(
                                    text: 'are compulsory',
                                    style: MyFonts.w500.setColor(kWhite3).size(12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          resetText(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Name',
                              // validator: validatefield,
                              isNecessary: false,
                              controller: _nameController,
                              isEnabled: false,
                            ),
                            const SizedBox(height: 12),
                            CustomDropDown(
                              value: hostel,
                              items: hostels,
                              label: 'Hostel',
                              onChanged: (h) => hostel = h,
                              validator: validatefield,
                            ),
                            const SizedBox(height: 12),
                            CustomDropDown(
                              value: program,
                              items: kprograms,
                              label: 'Program',
                              onChanged: (p) => program = p,
                              validator: validatefield,
                            ),
                            const SizedBox(height: 12),
                            CustomDropDown(
                              value: department,
                              items: kdepartments,
                              label: 'Department',
                              onChanged: (d) => department = d,
                              validator: validatefield,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Hostel room no',
                              validator: validatefield,
                              isNecessary: true,
                              controller: _roomNoController,
                              maxLength: 5,
                              maxLines: 1,
                              counter: true,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Roll Number',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be empty';
                                } else if (value.length != 9) {
                                  return 'Enter valid roll number';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              isNecessary: true,
                              controller: _rollController,
                              maxLength: 9,
                              maxLines: 1,
                              counter: true,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Phone Number',
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be empty';
                                } else if (value.length != 10) {
                                  return 'Enter valid 10 digit phone number';
                                }
                                return null;
                              },
                              isNecessary: true,
                              controller: _phoneController,
                              inputType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 10,
                              maxLines: 1,
                              counter: true,
                            ),
                            const SizedBox(height: 12),
                            buildDestinationSuggestions(),
                            if (selectedDestination == "Other")
                              CustomTextField(
                                label: 'Destination',
                                isNecessary: true,
                                controller: _destinationController,
                                maxLength: 50,
                                counter: true,
                                validator: selectedDestination == "Other" ? validatefield : null,
                              ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showQRImage();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: lBlue2,
                          ),
                          child: const Text(
                            'Generate QR',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  InkWell resetText() {
    return InkWell(
      onTap: resetForm,
      child: Text(
        "Reset",
        style: MyFonts.w500.size(12).setColor(lBlue2),
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget buildDestinationSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Destination: ",
            style: MyFonts.w500.size(14).setColor(kWhite2),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              children: destinationSuggestions
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDestination = e;
                        });
                      },
                      child: buildDestinationChip(e, selectedDestination == e),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDestinationChip(String destination, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        color: selected ? lBlue2 : Colors.transparent,
        border: !selected ? Border.all(color: lBlue2, width: 1) : null,
      ),
      child: Text(
        destination,
        style: selected ? MyFonts.w500.size(14) : MyFonts.w500.size(14).setColor(lBlue2),
      ),
    );
  }
}
