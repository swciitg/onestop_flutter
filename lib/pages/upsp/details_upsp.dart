import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/hostels.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';

class DetailsUpsp extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailsUpsp({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailsUpsp> createState() => _DetailsUpspState();
}

class _DetailsUpspState extends State<DetailsUpsp> {
  bool submitted = false;
  TextEditingController contact = TextEditingController();
  TextEditingController rollNo = TextEditingController();
  List<String> hostels = khostels;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userData = LoginStore.userData;
    String email = userData['outlookEmail']!;
    String name = userData['name']!;
    rollNo.text = userData['rollNo']!.toString();
    String selectedDropdown = userData['hostel']!;
    contact.text=userData['phoneNumber']!.toString();
    
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
          "2. Your Details",
          style: MyFonts.w600.size(16).setColor(kWhite),
        ),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              const ProgressBar(blue: 2, grey: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                        child: Text(
                          "Your Roll Number",
                          style: MyFonts.w600.size(16).setColor(kWhite),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: kGrey2),
                                color: kBackground,
                                borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: TextFormField(
                                  controller: rollNo,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please fill your roll number";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.number,
                                  style: MyFonts.w500.size(16).setColor(kWhite),
                                  decoration: InputDecoration(
                                    errorStyle: MyFonts.w400,
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: 'Your Answer',
                                    hintStyle: const TextStyle(color: kGrey8),
                                  ),
                                ))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                        child: Text(
                          "Contact Number",
                          style: MyFonts.w600.size(16).setColor(kWhite),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
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
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  controller: contact,
                                  maxLength: 10,
                                  style: MyFonts.w500.size(16).setColor(kWhite),
                                  decoration: InputDecoration(
                                    errorStyle: MyFonts.w400,
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: 'Your Answer',
                                    hintStyle: const TextStyle(color: kGrey8),
                                  ),
                                ))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                        child: Text(
                          "Your Hostel",
                          style: MyFonts.w600.size(16).setColor(kWhite),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(canvasColor: kBlueGrey),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: DropdownButtonFormField<String>(
                            value: selectedDropdown,
                            validator: (val) {
                              if (val == null) {
                                return "Hostel can not be empty";
                              }
                              return null;
                            },
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text("Select your hostel",
                                  style: MyFonts.w500.setColor(kGrey8).size(16)),
                            ),
                            decoration: InputDecoration(
                              errorStyle: MyFonts.w400,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: kGrey8),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: kGrey8),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: kGrey8),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: kGrey8),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            icon: const Icon(
                              FluentIcons.chevron_down_24_regular,
                              color: kWhite,
                            ),
                            style: MyFonts.w600.size(14).setColor(kWhite),
                            onChanged: (data) {
                              setState(() {
                                selectedDropdown = data!;
                              });
                            },
                            items: hostels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    value,
                                    style: MyFonts.w600.size(14).setColor(kWhite),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          if(!submitted)
                            {
                              setState(() {
                                submitted = true;
                              });
                              Map<String, dynamic> data = widget.data;
                              data['phone'] = contact.text;
                              data['hostel'] = selectedDropdown;
                              data['name'] = name;
                              data['roll_number'] = rollNo.text;
                              data['email'] = email;
                              try {
                                var response = await APIService().postUPSP(data);
                                if (!mounted) return;
                                if (response['success']) {
                                  showSnackBar("Your problem has been successfully sent to respective au1thorities.");
                                  Navigator.popUntil(
                                      context, ModalRoute.withName(HomePage.id));
                                } else {
                                  showSnackBar("Some error occurred. Try again later");
                                  setState(() {
                                    submitted = false;
                                  });
                                }
                              } catch (err) {
                                showSnackBar("Please check you internet connection and try again");
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
    contact.dispose();
    super.dispose();
  }
}
