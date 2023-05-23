import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/profile/profile_model.dart';
import 'package:onestop_dev/pages/profile/profile_page.dart';
import 'package:onestop_dev/widgets/profile/custom_dropdown.dart';
import 'package:onestop_dev/widgets/profile/custom_text_field.dart';
import 'package:onestop_dev/functions/utility/validator.dart';
import 'package:provider/provider.dart';
import '../../functions/utility/show_snackbar.dart';
import '../../globals/my_fonts.dart';
import '../../stores/login_store.dart';
import '../../widgets/profile/custom_date_picker.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel? profileModel;
  const EditProfile({Key? key, this.profileModel}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _outlookController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  String? hostel;
  DateTime? selectedDate;
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
    if (widget.profileModel != null) {
      ProfileModel p = widget.profileModel!;
      _usernameController.text = p.username;
      _rollController.text = p.rollNumber;
      _outlookController.text = p.outlook;
      _gmailController.text = p.gmail;
      _contactController.text = p.contact;
      _emergencyController.text = p.emergencyContact;
      _dateController.text = DateFormat('dd-MMM-yyyy').format(p.date!);
      _linkedinController.text = p.linkedin!;
      hostel = p.hostel;
      selectedDate = p.date;
    }else{
      _usernameController.text = "${context.read<LoginStore>().userData['name']}";
      _rollController.text = "${context.read<LoginStore>().userData['rollno']}";
      _outlookController.text = "${context.read<LoginStore>().userData['email']}";
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onFormSubmit() async {
      if (!_formKey.currentState!.validate()) {
        showSnackBar('Please give all the inputs correctly');
        return;
      } else {
        DateTime date = DateTime(
            selectedDate!.year, selectedDate!.month, selectedDate!.day);
        var data = {
          'username': _usernameController.text,
      'rollNumber': _rollController.text,
      'outlook': _outlookController.text,
      'gmail': _gmailController.text,
      'contact': _contactController.text,
      'emergencyContact': _emergencyController.text,
      'hostel': hostel,
      'linkedin': _linkedinController.text,
      'date': date.toIso8601String(),
        };

        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Profile(profileModel: ProfileModel.fromJson(data),)),((route) => false));
      }
    }

    return Scaffold(
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
              Center(
                  child: Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(75)),
                      color: kWhite2),
                  child: Image.asset(
                    'assets/images/class.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                        color: kWhite2),
                    child: Icon(Icons.edit_outlined),
                  ),
                ),
              ])),
              const SizedBox(
                height: 24,
              ),
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
                        hintText: 'Username',
                        // validator: validatefield,
                        isNecessary: false,
                        controller: _usernameController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Roll Number',
                        // validator: validatefield,
                        isNecessary: false,
                        controller: _rollController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Outlook ID',
                        // validator: validatefield,
                        isNecessary: false,
                        controller: _outlookController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Gmail',
                        validator: validatefield,
                        isNecessary: true,
                        controller: _gmailController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Contact Number',
                        validator: validatefield,
                        isNecessary: true,
                        controller: _contactController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Emergency Contact Number',
                        validator: validatefield,
                        isNecessary: true,
                        controller: _emergencyController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomDropDown(
                        value: hostel,
                          items: hostels,
                          hintText: 'Hostel',
                          onChanged: (h) => hostel = h,
                          validator: validatefield),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        hintText: 'Date',
                        validator: validatefield,
                        controller: _dateController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101),
                              builder: (context, child) => CustomDatePicker(
                                    child: child,
                                  ));
                          if (pickedDate != null) {
                            if (!mounted) return;
                            selectedDate = pickedDate;
                            String formattedDate =
                                DateFormat('dd-MMM-yyyy').format(pickedDate);
                            setState(() {
                              _dateController.text =
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
                        hintText: 'LinkedIn Profile',
                        // validator: validatefield,
                        isNecessary: false,
                        controller: _linkedinController,
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
    );
  }
}
