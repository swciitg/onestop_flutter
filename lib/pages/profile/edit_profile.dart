import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions/utility/show_snackbar.dart';
import '../../functions/utility/validator.dart';
import '../../globals/my_colors.dart';
import '../../stores/login_store.dart';
import '../../widgets/profile/custom_date_picker.dart';
import '../../widgets/profile/custom_dropdown.dart';
import '../../widgets/profile/custom_text_field.dart';

class EditProfile extends StatefulWidget {
  final OneStopUser profileModel;

  const EditProfile({Key? key, required this.profileModel}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _outlookEmailController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _altEmailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _cycleRegController = TextEditingController();
  late Hostel hostel;
  late Mess mess;
  String? gender;
  DateTime? selectedDob;

  // String? imageString;
  final List<String> genders = ["Male", "Female", "Others"];
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    OneStopUser p = widget.profileModel;
    _nameController.text = p.name;
    _rollController.text = p.rollNo;
    _outlookEmailController.text = p.outlookEmail;
    _altEmailController.text = p.altEmail ?? "";
    _phoneController.text =
        p.phoneNumber == null ? "" : p.phoneNumber.toString();
    _emergencyController.text =
        p.emergencyPhoneNumber == null ? "" : p.emergencyPhoneNumber.toString();
    _roomNoController.text = p.roomNo ?? "";
    _homeAddressController.text = p.homeAddress ?? "";
    _dobController.text = DateFormat('dd-MMM-yyyy')
        .format(DateTime.parse(p.dob ?? DateTime.now().toIso8601String()));
    _linkedinController.text = p.linkedin ?? "";
    hostel = p.hostel?.getHostelFromDatabaseString() ?? Hostel.none;
    mess = p.subscribedMess?.getMessFromDatabaseString() ?? Mess.none;
    gender = p.gender;
    selectedDob = p.dob != null ? DateTime.parse(p.dob!) : DateTime.now();
    _cycleRegController.text = p.cycleReg ?? "";
    // imageString = p.image;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onFormSubmit() async {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        if (!_formKey.currentState!.validate()) {
          showSnackBar('Please give all the inputs correctly');
          setState(() {
            isLoading = false;
          });
          return;
        } else {
          DateTime date =
              DateTime(selectedDob!.year, selectedDob!.month, selectedDob!.day);
          var data = {
            'name': _nameController.text,
            'rollNo': _rollController.text,
            'outlookEmail': _outlookEmailController.text,
            'altEmail': _altEmailController.text,
            'dob': date.toIso8601String(),
            'gender': gender,
            'phoneNumber': _phoneController.text,
            'emergencyPhoneNumber': _emergencyController.text,
            'hostel': hostel.databaseString,
            'roomNo': _roomNoController.text,
            'homeAddress': _homeAddressController.text,
            'cycleReg': _cycleRegController.text,
            'linkedin': _linkedinController.text,
            'subscribedMess': mess.databaseString
          };
          print(data);
          try {
            await APIService().updateUserProfile(data, null);
            await LocalStorage.instance.deleteRecord(DatabaseRecords.timetable);
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            showSnackBar(e.toString());
            return;
          }
          Map userInfo = await APIService().getUserProfile();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("userInfo", jsonEncode(userInfo));
          await LoginStore().saveToUserInfo(
              prefs); // automatically updates token & other user info
          await prefs.setBool("isProfileComplete", true); // profile is complete
          await LocalStorage.instance.deleteRecord(DatabaseRecords.timetable);
          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBarGrey,
          iconTheme: const IconThemeData(color: kAppBarGrey),
          automaticallyImplyLeading: false,
          centerTitle: true,
          // leadingWidth: 16,
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
            "Profile Setup",
            textAlign: TextAlign.left,
            style: OnestopFonts.w500.size(23).setColor(kWhite),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (isLoading) const LinearProgressIndicator(),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Fields marked with',
                                style: OnestopFonts.w500
                                    .setColor(kWhite3)
                                    .size(12)),
                            TextSpan(
                                text: ' * ',
                                style:
                                    OnestopFonts.w500.setColor(kRed).size(12)),
                            TextSpan(
                                text: 'are compulsory',
                                style: OnestopFonts.w500
                                    .setColor(kWhite3)
                                    .size(12)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      // For now image will not be stored
                      // Center(
                      //     child: Stack(alignment: Alignment.bottomRight, children: [
                      //
                      //   ClipRRect(
                      //       borderRadius: BorderRadius.circular(75.0),
                      //
                      //       child: Image(
                      //         image: imageString==null?const ResizeImage(AssetImage('assets/images/profile_placeholder.png'),width: 150,height: 150): ResizeImage(
                      //             MemoryImage(base64Decode(imageString!))
                      //             ,width: 150,
                      //         height: 150,),
                      //         fit: BoxFit.fill,
                      //       )
                      //       ),
                      //   Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: GestureDetector(
                      //       onTap: () async {
                      //         XFile? xFile;
                      //         await showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return AlertDialog(
                      //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      //                 backgroundColor: kBlueGrey,
                      //                   title:  Text(
                      //                       "Do you want to change your profile photo?",style: OnestopFonts.w500.size(16).setColor(kWhite2),),
                      //                   content: SingleChildScrollView(
                      //                     child: ListBody(
                      //                       children: <Widget>[
                      //                          GestureDetector(
                      //                           child:  Text("Take Photo",style: OnestopFonts.w500.size(14).setColor(kWhite),),
                      //                           onTap: () async {
                      //                             xFile = await ImagePicker().pickImage(
                      //                                 source: ImageSource.camera);
                      //                             if (!mounted) return;
                      //                             Navigator.of(context).pop();
                      //                           },
                      //                         ),
                      //                         const Padding(
                      //                             padding: EdgeInsets.all(8.0)),
                      //                             GestureDetector(
                      //                           child:  Text("Choose Photo",style: OnestopFonts.w500.size(14).setColor(kWhite),),
                      //                           onTap: () async {
                      //                             xFile = await ImagePicker().pickImage(
                      //                                 source: ImageSource.gallery);
                      //                             if (!mounted) return;
                      //                             Navigator.of(context).pop();
                      //                           },
                      //                         ),
                      //                         const Padding(
                      //                             padding: EdgeInsets.all(8.0)),
                      //
                      //                         GestureDetector(
                      //                           child: Text("Remove Photo",style: OnestopFonts.w500.size(14).setColor(kRed),),
                      //                           onTap: () async {
                      //                             setState(() {
                      //                               imageString=null;
                      //                             });
                      //                             return
                      //                             Navigator.of(context).pop();
                      //                           },
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ));
                      //             });
                      //
                      //         if (!mounted) return;
                      //         if (xFile != null) {
                      //           var bytes = File(xFile!.path).readAsBytesSync();
                      //           var imageSize = (bytes.lengthInBytes /
                      //               (1048576)); // dividing by 1024*1024
                      //           if (imageSize > 2.5) {
                      //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //                 content: Text(
                      //               "Maximum image size can be 2.5 MB",
                      //               style: OnestopFonts.w500,
                      //             )));
                      //             return;
                      //           }
                      //           setState(() {
                      //             imageString = base64Encode(bytes);
                      //           });
                      //           return;
                      //         }
                      //       },
                      //       child: Container(
                      //         height: 30,
                      //         width: 30,
                      //         decoration: const BoxDecoration(
                      //             borderRadius: BorderRadius.all(Radius.circular(75)),
                      //             color: kWhite),
                      //         child: const Icon(Icons.edit_outlined),
                      //       ),
                      //     ),
                      //   ),
                      // ])),
                      // const SizedBox(
                      //   height: 24,
                      // ),
                      Text('Basic Information',
                          style: OnestopFonts.w600.size(16).setColor(kWhite)),
                      const SizedBox(
                        height: 18,
                      ),
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
                              const SizedBox(
                                height: 12,
                              ),
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
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                isEnabled: false,
                                label: 'Outlook Email ID',
                                // validator: validatefield,
                                isNecessary: false,
                                controller: _outlookEmailController,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Alt Email ID',
                                validator: validatefield,
                                isNecessary: true,
                                controller: _altEmailController,
                                maxLength: 50,
                                maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
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
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Emergency Contact Number',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Field cannot be empty';
                                  } else if (value.length != 10) {
                                    return 'Enter valid 10 digit phone number';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                isNecessary: true,
                                controller: _emergencyController,
                                inputType: TextInputType.phone,
                                maxLength: 10,
                                maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomDropDown(
                                  value: gender,
                                  items: genders,
                                  label: 'Your Gender',
                                  onChanged: (g) => gender = g,
                                  validator: validatefield),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomDropDown(
                                value: hostel.displayString,
                                items: Hostel.values.displayStrings(),
                                label: 'Hostel',
                                onChanged: (String h) =>
                                    hostel = h.getHostelFromDisplayString()!,
                                validator: (String? value) {
                                  if (value == null) {
                                    return 'Field cannot be empty';
                                  }
                                  final selectedHostel =
                                      value.getHostelFromDisplayString();
                                  if (selectedHostel == null ||
                                      selectedHostel == Hostel.none) {
                                    return 'Field cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomDropDown(
                                  value: mess.displayString,
                                  items: Mess.values.displayStrings(),
                                  label: 'Subscribed Mess',
                                  onChanged: (String m) =>
                                      mess = m.getMessFromDisplayString()!,
                                  validator: (String? value) {
                                    {
                                      return null;
                                    }
                                  }),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Date of Birth',
                                validator: validatefield,
                                controller: _dobController,
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDob ?? DateTime.now(),
                                      firstDate: DateTime(1920),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101),
                                      builder: (context, child) =>
                                          CustomDatePicker(
                                            child: child,
                                          ));
                                  if (pickedDate != null) {
                                    if (!mounted) return;
                                    selectedDob = pickedDate;
                                    String formattedDate =
                                        DateFormat('dd-MMM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      _dobController.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  }
                                },
                                isNecessary: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Hostel Room Number',
                                validator: validatefield,
                                isNecessary: true,
                                controller: _roomNoController,
                                maxLength: 5,
                                maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Home Address',
                                validator: validatefield,
                                isNecessary: true,
                                controller: _homeAddressController,
                                maxLength: 400,
                                // maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'Cycle Registration Number',
                                isNecessary: false,
                                controller: _cycleRegController,
                                maxLength: 5,
                                maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                label: 'LinkedIn Profile',
                                // validator: validatefield,
                                isNecessary: false,
                                controller: _linkedinController,
                                maxLength: 50,
                                maxLines: 1,
                                counter: true,
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                            ],
                          )),
                      GestureDetector(
                        onTap: onFormSubmit,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: lBlue2),
                          child: const Text(
                            'Submit',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
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
}
