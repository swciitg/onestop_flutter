import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../functions/utility/show_snackbar.dart';
import '../../functions/utility/validator.dart';
import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../models/profile/profile_model.dart';
import '../../stores/login_store.dart';
import '../../widgets/profile/custom_date_picker.dart';
import '../../widgets/profile/custom_dropdown.dart';
import '../../widgets/profile/custom_text_field.dart';
import 'profile_page.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel profileModel;
  const EditProfile({Key? key,required this.profileModel}) : super(key: key);

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
  String? hostel;
  String? gender;
  DateTime? selectedDob;
  // String? imageString;
  final List<String> genders = [
    "Male",
    "Female",
    "Others"
  ];
  final List<String> hostels = [
    "Kameng",
    "Barak",
    "Lohit",
    "Brahma",
    "Disang",
    "Manas",
    "Dihing",
    "Umiam",
    "Siang",
    "Kapili",
    "Dhansiri",
    "Subhansiri"
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ProfileModel p = widget.profileModel!;
    _nameController.text = p.name;
    _rollController.text = p.rollNo;
    _outlookEmailController.text = p.outlookEmail;
    _altEmailController.text = p.altEmail ?? "";
    _phoneController.text =p.phoneNumber==null?"": p.phoneNumber.toString();
    _emergencyController.text = p.emergencyPhoneNumber==null?"": p.emergencyPhoneNumber.toString();
    _roomNoController.text = p.roomNo ?? "";
    _homeAddressController.text = p.homeAddress ?? "";
    _dobController.text = DateFormat('dd-MMM-yyyy').format(DateTime.parse(p.dob ?? DateTime.now().toIso8601String()));
    _linkedinController.text = p.linkedin ?? "";
    hostel = p.hostel;
    gender = p.gender;
    selectedDob = p.dob!=null ? DateTime.parse(p.dob!) : DateTime.now();
    // imageString = p.image;
  }

  @override
  Widget build(BuildContext context) {
    Widget? counterBuilder(context,
      {required currentLength, required isFocused, required maxLength}) {
    if (currentLength == 0) {
      return null;
    }
    return Text("$currentLength/$maxLength",
        style: MyFonts.w500.size(12).setColor(kWhite));
  }
    Future<void> onFormSubmit() async {
      if (!_formKey.currentState!.validate()) {
        showSnackBar('Please give all the inputs correctly');
        return;
      } else {
        DateTime date = DateTime(
            selectedDob!.year, selectedDob!.month, selectedDob!.day);
        var data = {
          'name': _nameController.text,
          'rollNo': _rollController.text,
          'outlookEmail': _outlookEmailController.text,
          'altEmail': _altEmailController.text,
          'dob': date.toIso8601String(),
          'gender': gender,
          'phoneNumber': _phoneController.text,
          'emergencyPhoneNumber': _emergencyController.text,
          'hostel': hostel,
          'roomNo': _roomNoController.text,
          'homeAddress': _homeAddressController.text,
          'linkedin': _linkedinController.text
        };
        print(data);
       await APIService().updateUserProfile(data,null);
        Map userInfo = await APIService().getUserProfile();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('hostel', hostel??"");
        await prefs.setString("userInfo", jsonEncode(userInfo));
        await context.read<LoginStore>().saveToUserInfo(prefs); // automatically updates token & other user info
        await prefs.setBool("isProfileComplete", true); // profile is complete
        print("PROFILE COMPLETED");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => Profile(
        //               profileModel: ProfileModel.fromJson(data),
        //             )),
        //     ((route) => false));
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kAppBarGrey,
          iconTheme: const IconThemeData(color: kAppBarGrey),
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            "Profile Setup",
            textAlign: TextAlign.left,
            style: MyFonts.w500.size(23).setColor(kWhite),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Fields marked with',
                          style: MyFonts.w500.setColor(kWhite3).size(12)),
                      TextSpan(
                          text: ' * ',
                          style: MyFonts.w500.setColor(kRed).size(12)),
                      TextSpan(
                          text: 'are compulsory',
                          style: MyFonts.w500.setColor(kWhite3).size(12)),
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
                //                       "Do you want to change your profile photo?",style: MyFonts.w500.size(16).setColor(kWhite2),),
                //                   content: SingleChildScrollView(
                //                     child: ListBody(
                //                       children: <Widget>[
                //                          GestureDetector(
                //                           child:  Text("Take Photo",style: MyFonts.w500.size(14).setColor(kWhite),),
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
                //                           child:  Text("Choose Photo",style: MyFonts.w500.size(14).setColor(kWhite),),
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
                //                           child: Text("Remove Photo",style: MyFonts.w500.size(14).setColor(kRed),),
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
                //               style: MyFonts.w500,
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
                    style: MyFonts.w600.size(16).setColor(kWhite)),
                const SizedBox(
                  height: 18,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'name',
                          // validator: validatefield,
                          isNecessary: false,
                          controller: _nameController,
                          isEnabled: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Roll Number',
                          // validator: validatefield,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                          isNecessary: false,
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
                          hintText: 'outlookEmail ID',
                          // validator: validatefield,
                          isNecessary: false,
                          controller: _outlookEmailController,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Alt Email',
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
                          hintText: 'Phone Number',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            else if(value.length!=10){
                              return 'Enter valid 10 digit phone number';
                            }
                            return null;
                          },
                          isNecessary: true,
                          controller: _phoneController,
                          inputType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                          maxLength: 10,
                          maxLines: 1,
                          counter: true,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Emergency Contact Number',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            else if(value.length!=10){
                              return 'Enter valid 10 digit phone number';
                            }
                            return null;
                          },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
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
                            hintText: 'Your Gender',
                            onChanged: (g) => gender = g,
                            validator: validatefield),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomDropDown(
                            value: hostel,
                            items: hostels,
                            hintText: 'Hostel',
                            onChanged: (h) => hostel = h,
                            validator: validatefield,
                            ),
                            
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Date of Birth',
                          validator: validatefield,
                          controller: _dobController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDob ?? DateTime.now(),
                                firstDate: DateTime(1990),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101),
                                builder: (context, child) => CustomDatePicker(
                                      child: child,
                                    ));
                            if (pickedDate != null) {
                              if (!mounted) return;
                              selectedDob = pickedDate;
                              String formattedDate =
                                  DateFormat('dd-MMM-yyyy').format(pickedDate);
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
                          hintText: 'Hostel room no',
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
                          hintText: 'Home Address',
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
                          hintText: 'LinkedIn Profile',
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
                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
          )),
        ),
      ),
    );
  }
}
