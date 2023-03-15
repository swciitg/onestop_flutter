import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/pages/elections/voter_card.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../widgets/lostfound/new_page_button.dart';
import '../../widgets/ui/appbar.dart';

class RegisterScreen extends StatefulWidget {
  static const id = "/electionRegister";
  String authCookie;
  RegisterScreen({Key? key, required this.authCookie}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String roll = '';
  String email = '';
  String hostel = 'Kameng';
  String degree = 'BTech';
  String gender = 'Male';
  String branch = 'CSE';
  bool submitted = false;


  List<String> hostels = [
    'Lohit',
    'Brahmaputra',
    'Siang',
    'Manas',
    'Dibang',
    'Disang',
    'Kameng',
    'Umiam',
    'Barak',
    'Kapili',
    'Dihing',
    'Subansiri',
    'Dhansiri',
    'Married Scholar Hostel',
    'Not Alloted',
  ];

  Map<String, String> branches = {
    "None": 'None',
    'CSE': '01',
    'ECE': '02',
    'ME': '03',
    'Civil': '04',
    'Design': '05',
    'BSBE': '06',
    'CL': '07',
    'EEE': '08',
    'Physics': '21',
    'Chemistry': '22',
    'MNC': '23',
    'HSS': '41',
    'Energy': '51',
    'Environment': '52',
    'Nano-Tech': '53',
    'Rural-Tech': '54',
    'Linguistics': '55',
    'Others': '61',
  };

  Map<String, String> degrees = {
    "B.Tech": "B",
    "M.Tech": "M",
    "PhD": "P",
    "MSc": "Msc",
    "Bdes": "Bdes",
    "Mdes": "Mdes",
    "Dual Degree": "Dual",
    "MA": "MA",
    "MSR": "MSR"
  };

  @override
  Widget build(BuildContext context) {
    dio.options.headers['cookie'] =
        widget.authCookie; // setting cookies for auth
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, displayIcon: false),
        body: FutureBuilder<Response>(
            future: dio.get("https://swc.iitg.ac.in/elections_api/sgc/profile"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ListShimmer(
                  count: 1,
                  height: 750,
                );
              }
              Response profResp = snapshot.data!;
              if (profResp.data["euser"]["registration_complete"] == false) {
                // show form and generate voter card
                name = profResp.data["euser"]['name'];
                roll = profResp.data['last_name']!;
                email = profResp.data["euser"]['email'];
                return Form(
                  key: _formKey,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 15, bottom: 10),
                                  child: Text(
                                    "Your Name",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
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
                                            initialValue: name,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "Please fill your name";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                            decoration: InputDecoration(
                                              errorStyle: MyFonts.w400,
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
                                    "Roll number",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
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
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "Please fill your roll number";
                                              }
                                              if (val.length < 9) {
                                                return "Enter a valid roll number";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            initialValue: roll,
                                            onChanged: (r) => roll = r,
                                            maxLength: 9,
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                            decoration: InputDecoration(
                                              errorStyle: MyFonts.w400,
                                              counterText: "",
                                              border: InputBorder.none,
                                              hintText: 'Ex: 200101071',
                                              hintStyle:
                                                  const TextStyle(color: kGrey8),
                                            ),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 15, bottom: 10),
                                  child: Text(
                                    "Your Hostel",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: kBlueGrey),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: DropdownButtonFormField<String>(
                                      validator: (val) {
                                        if (val == null) {
                                          return "Hostel can not be empty";
                                        }
                                        return null;
                                      },
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Select your hostel",
                                            style: MyFonts.w500
                                                .setColor(kGrey8)
                                                .size(16)),
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: MyFonts.w400,
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
                                      style:
                                          MyFonts.w600.size(14).setColor(kWhite),
                                      onChanged: (data) {
                                        setState(() {
                                          hostel = data!;
                                        });
                                      },
                                      menuMaxHeight: 250,
                                      items: hostels
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              value,
                                              style: MyFonts.w600
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
                                    "Degree",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: kBlueGrey),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: DropdownButtonFormField<String>(
                                      validator: (val) {
                                        if (val == null) {
                                          return "Degree can not be empty";
                                        }
                                        return null;
                                      },
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Select your degree",
                                            style: MyFonts.w500
                                                .setColor(kGrey8)
                                                .size(16)),
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: MyFonts.w400,
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
                                      style:
                                          MyFonts.w600.size(14).setColor(kWhite),
                                      onChanged: (data) {
                                        setState(() {
                                          degree = data!;
                                        });
                                      },
                                      menuMaxHeight: 250,
                                      items: degrees.keys
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              value,
                                              style: MyFonts.w600
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
                                    "Gender",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: kBlueGrey),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: DropdownButtonFormField<String>(
                                      validator: (val) {
                                        if (val == null) {
                                          return "Gender can not be empty";
                                        }
                                        return null;
                                      },
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Select your degree",
                                            style: MyFonts.w500
                                                .setColor(kGrey8)
                                                .size(16)),
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: MyFonts.w400,
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
                                      style:
                                          MyFonts.w600.size(14).setColor(kWhite),
                                      onChanged: (data) {
                                        setState(() {
                                          gender = data!;
                                        });
                                      },
                                      menuMaxHeight: 250,
                                      items: ["Male", "Female"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              value,
                                              style: MyFonts.w600
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
                                    "Branch",
                                    style: MyFonts.w600.size(16).setColor(kWhite),
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: kBlueGrey),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    child: DropdownButtonFormField<String>(
                                      validator: (val) {
                                        if (val == null) {
                                          return "Branch can not be empty";
                                        }
                                        return null;
                                      },
                                      hint: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Text("Select your branch",
                                            style: MyFonts.w500
                                                .setColor(kGrey8)
                                                .size(16)),
                                      ),
                                      decoration: InputDecoration(
                                        errorStyle: MyFonts.w400,
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
                                      style:
                                          MyFonts.w600.size(14).setColor(kWhite),
                                      onChanged: (data) {
                                        setState(() {
                                          branch = data!;
                                        });
                                      },
                                      menuMaxHeight: 250,
                                      items: branches.keys
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              value,
                                              style: MyFonts.w600
                                                  .size(14)
                                                  .setColor(kWhite),
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
                                    if (!submitted) {
                                      setState(() {
                                        submitted = true;
                                      });
                                      try {
                                        var data = {
                                          "name": name,
                                          "roll_number": roll,
                                          "degree": degrees[degree],
                                          "branch": branches[branch],
                                          "hostel": hostel.toLowerCase(),
                                          "gender": gender
                                        };
                                        print(data);
                                        Response resp = await dio.patch(
                                            'https://swc.iitg.ac.in/elections_api/sgc/registration/complete/',
                                            data: data);
                                        print(resp);
                                      } catch (e) {
                                        setState(() {
                                          submitted = false;
                                        });
                                        print(e);
                                        showSnackBar(
                                            'Please check your internet');
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
                );
              } else {
                // show voter card
                //print(profResp.data["euser"]);
                // Response resp = await dio.patch(
                //     'https://swc.iitg.ac.in/elections_api/sgc/registration/complete/',
                //     data: data);
                // print(resp);
                return VoterCard(
                  email: profResp.data["euser"]["email"],
                  authCookie: widget.authCookie,
                );
              }
            }),
      ),
    );
  }
}
