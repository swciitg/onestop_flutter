import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/pages/elections/election_local_keys.dart';
import 'package:onestop_dev/pages/elections/voter_card.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static const id = "/electionRegister";
  final String authCookie;
  final String? cachedEmail;
  final bool showVoterCardDirect;

  const RegisterScreen({
    super.key,
    required this.authCookie,
    this.cachedEmail,
    this.showVoterCardDirect = false,
  });

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

  Future<void> _persistElectionSession({
    required String email,
    required String authCookie,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ElectionLocalKeys.isRegistered, true);
    await prefs.setString(ElectionLocalKeys.email, email);
    await prefs.setString(ElectionLocalKeys.authCookie, authCookie);
  }

  Future<void> _clearElectionSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ElectionLocalKeys.isRegistered);
    await prefs.remove(ElectionLocalKeys.email);
    await prefs.remove(ElectionLocalKeys.authCookie);
  }

  Future<void> _handleLogout() async {
    await _clearElectionSession();
    if (!mounted) return;
    showSnackBar('Logged out from Elections');
    Navigator.of(context).pop();
  }

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
    'Gaurang',
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
    'DSAI': '50',
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
    "MSR": "MSR",
    "MBA": "MBA",
    "Others": "Others",
  };

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
      errorStyle: OTextStyle.labelXSmall.copyWith(color: OColor.red500),
      filled: true,
      fillColor: OColor.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.gray200),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.green600),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.red500),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.red500),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
    );
  }

  InputDecoration _textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
      errorStyle: OTextStyle.labelXSmall.copyWith(color: OColor.red500),
      counterText: "",
      filled: true,
      fillColor: OColor.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.gray200),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.gray200),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.green600),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.red500),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.red500),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: OColor.gray200),
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dio.options.headers['cookie'] = widget.authCookie;

    if (widget.showVoterCardDirect && widget.cachedEmail != null) {
      return Scaffold(
        backgroundColor: OColor.gray100,
        appBar: AppBar(
          backgroundColor: OColor.white,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: OColor.green600),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              tooltip: 'Logout',
              icon: Icon(Icons.logout, color: OColor.green600),
              onPressed: _handleLogout,
            ),
          ],
          title: Text(
            'Elections',
            style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
          ),
          systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle
              ?.copyWith(statusBarColor: OColor.white),
        ),
        body: VoterCard(
          email: widget.cachedEmail!,
          authCookie: widget.authCookie,
        ),
      );
    }

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: OColor.green600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Elections',
          style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout, color: OColor.green600),
            onPressed: _handleLogout,
          ),
        ],
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle
            ?.copyWith(statusBarColor: OColor.white),
      ),
      body: FutureBuilder<Response>(
        future: dio.get("https://swc.iitg.ac.in/elections_api/sgc/profile"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log("REGISTER SCREEN ERROR: ${snapshot.error}");
            if (snapshot.error is DioException) {
              log(
                "REGISTER SCREEN ERROR: ${(snapshot.error as DioException).message}",
              );
            }
            return Center(
              child: Text(
                "Something went wrong!",
                style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return ListShimmer(count: 1, height: 750);
          }

          Response profResp = snapshot.data!;
          if (profResp.data["euser"]["registration_complete"] == false) {
            name = profResp.data["euser"]['name'];
            roll = profResp.data['last_name']!;
            email = profResp.data["euser"]['email'];
            String code = profResp.data["euser"]['degree'];

            degree =
                degrees.entries
                    .firstWhere(
                      (entry) => entry.value == code,
                      orElse: () => MapEntry(code, code),
                    )
                    .key;
            log("REGISTER SCREEN DATA: ${profResp.data}");
            return Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(OSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      _fieldLabel('Your Name'),
                      TextFormField(
                        initialValue: name,
                        enabled: false,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        decoration: _textFieldDecoration('Your Name'),
                        validator:
                            (val) =>
                                (val == null || val.isEmpty)
                                    ? "Please fill your name"
                                    : null,
                      ),
                      const SizedBox(height: OSpacing.m),

                      // Roll number
                      _fieldLabel('Roll Number'),
                      TextFormField(
                        initialValue: roll,
                        keyboardType: TextInputType.number,
                        maxLength: 9,
                        enabled: false,
                        onChanged: (r) => roll = r,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        decoration: _textFieldDecoration('Ex: 200101071'),
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "Please fill your roll number";
                          if (val.length < 9)
                            return "Enter a valid roll number";
                          return null;
                        },
                      ),
                      const SizedBox(height: OSpacing.m),

                      // Degree
                      _fieldLabel('Degree'),
                      TextFormField(
                        initialValue: degree,
                        keyboardType: TextInputType.number,
                        maxLength: 9,
                        enabled: false,
                        onChanged: (r) => degree = r,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        decoration: _textFieldDecoration('Ex: 200101071'),
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "Please fill your roll number";
                          if (val.length < 9)
                            return "Enter a valid roll number";
                          return null;
                        },
                      ),

                      const SizedBox(height: OSpacing.m),

                      // Hostel
                      _fieldLabel('Your Hostel'),
                      DropdownButtonFormField<String>(
                        hint: Text(
                          "Select your hostel",
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray400,
                          ),
                        ),
                        decoration: _dropdownDecoration('Select your hostel'),
                        icon: Icon(
                          FluentIcons.chevron_down_24_regular,
                          color: OColor.gray600,
                        ),
                        dropdownColor: OColor.white,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        onChanged: (data) => setState(() => hostel = data!),
                        menuMaxHeight: 250,
                        validator:
                            (val) =>
                                val == null ? "Hostel can not be empty" : null,
                        items:
                            hostels.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: OSpacing.m),

                      // DropdownButtonFormField<String>(
                      //   hint: Text(
                      //     "Select your degree",
                      //     style: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
                      //   ),
                      //   decoration: _dropdownDecoration('Select your degree'),
                      //   icon: Icon(FluentIcons.chevron_down_24_regular, color: OColor.gray600),
                      //   dropdownColor: OColor.white,
                      //   style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                      //   onChanged: (data) => setState(() => degree = data!),
                      //   menuMaxHeight: 250,
                      //   validator: (val) => val == null ? "Degree can not be empty" : null,
                      //   items:
                      //       degrees.keys.map<DropdownMenuItem<String>>((String value) {
                      //         return DropdownMenuItem<String>(value: value, child: Text(value));
                      //       }).toList(),
                      // ),
                      const SizedBox(height: OSpacing.m),

                      // Gender
                      _fieldLabel('Gender'),
                      DropdownButtonFormField<String>(
                        hint: Text(
                          "Select your gender",
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray400,
                          ),
                        ),
                        decoration: _dropdownDecoration('Select your gender'),
                        icon: Icon(
                          FluentIcons.chevron_down_24_regular,
                          color: OColor.gray600,
                        ),
                        dropdownColor: OColor.white,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        onChanged: (data) => setState(() => gender = data!),
                        menuMaxHeight: 250,
                        validator:
                            (val) =>
                                val == null ? "Gender can not be empty" : null,
                        items:
                            ["Male", "Female"].map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: OSpacing.m),

                      // Branch
                      _fieldLabel('Branch'),
                      DropdownButtonFormField<String>(
                        hint: Text(
                          "Select your branch",
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray400,
                          ),
                        ),
                        decoration: _dropdownDecoration('Select your branch'),
                        icon: Icon(
                          FluentIcons.chevron_down_24_regular,
                          color: OColor.gray600,
                        ),
                        dropdownColor: OColor.white,
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                        onChanged: (data) => setState(() => branch = data!),
                        menuMaxHeight: 250,
                        validator:
                            (val) =>
                                val == null ? "Branch can not be empty" : null,
                        items:
                            branches.keys.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: OSpacing.l),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              submitted
                                  ? null
                                  : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    setState(() => submitted = true);
                                    try {
                                      var data = {
                                        "name": name,
                                        "roll_number": roll,
                                        "degree": degrees[degree],
                                        "branch": branches[branch],
                                        "hostel": hostel.toLowerCase(),
                                        "gender": gender,
                                      };
                                      await dio.patch(
                                        'https://swc.iitg.ac.in/elections_api/sgc/registration/complete/',
                                        data: data,
                                      );
                                      await _persistElectionSession(
                                        email: email,
                                        authCookie: widget.authCookie,
                                      );
                                      if (!mounted) return;
                                      setState(() => submitted = false);
                                    } catch (e) {
                                      setState(() => submitted = false);
                                      showSnackBar(
                                        'Please check your internet',
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: OColor.green600,
                            foregroundColor: OColor.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                OCornerRadius.m,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            submitted ? 'Submitting...' : 'Submit',
                            style: OTextStyle.labelMedium.copyWith(
                              color: OColor.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: OSpacing.m),
                    ],
                  ),
                ),
              ),
            );
          } else {
            _persistElectionSession(
              email: profResp.data["euser"]["email"],
              authCookie: widget.authCookie,
            );
            return VoterCard(
              email: profResp.data["euser"]["email"],
              authCookie: widget.authCookie,
            );
          }
        },
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OSpacing.xs),
      child: Text(
        label,
        style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
      ),
    );
  }
}
