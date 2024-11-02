import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/functions/utility/validator.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mess_store.dart';
import 'package:onestop_dev/widgets/profile/custom_dropdown.dart';
import 'package:onestop_dev/widgets/profile/custom_text_field.dart';
import 'package:onestop_dev/widgets/ui/simple_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../main.dart';

class MessOpiFormPage extends StatefulWidget {
  static const id = '/messOpiFormPage';

  const MessOpiFormPage({super.key});

  @override
  State<MessOpiFormPage> createState() => _MessOpiFormPageState();
}

class _MessOpiFormPageState extends State<MessOpiFormPage> {
  final TextEditingController _commentsController = TextEditingController();
  final user = OneStopUser.fromJson(LoginStore.userData);
  late bool isSmcMember;
  List<String> smcEmails = [];
  String errorMessage = '';
  late Hostel selectedHostel;
  int breakfast = 0;
  int lunch = 0;
  int dinner = 0;
  int wasteDisposal = 0;
  int punctuality = 0;
  int quality = 0;
  int hygiene = 0;
  bool isLoading = false;
  final List<Hostel> hostels = Hostel.values;
  final List<int> points = [1, 2, 3, 4, 5];
  final dropDownIcon = const Icon(
    Icons.keyboard_arrow_down_rounded,
    size: 24,
    color: kWhite,
  );

  @override
  void initState() {
    selectedHostel =
        user.hostel?.getHostelFromDatabaseString() ?? hostels.first;
    super.initState();
    _fetchSMCEmails();
    isSmcMember = isUserPartOfSMC(user.outlookEmail);
  }

  // Function to fetch SMC Emails
  Future<void> _fetchSMCEmails() async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Reset error message before fetching
    });

    try {
      final response =
          await http.get(Uri.parse('/test/onestop/api/v3/mess/opi/smc'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['smcEmails'] != null) {
          setState(() {
            smcEmails = List<String>.from(data['smcEmails']);
            isLoading = false;
          });
        } else {
          // Handle the case where success is false or smcEmails is null
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load SMC emails. Please try again later.';
          });
        }
      } else {
        // Handle HTTP error response
        setState(() {
          isLoading = false;
          errorMessage =
              'Server error: ${response.statusCode}. Please try again.';
        });
      }
    } catch (e) {
      // Handle connection or parsing error
      setState(() {
        isLoading = false;
        errorMessage =
            'An error occurred. Please check your internet connection and try again.';
      });
      print('Error: $e'); // Log the error for debugging purposes
    }
  }

  bool isUserPartOfSMC(String? userEmail) {
    if (userEmail == null) return false; // If no email is found, return false
    return smcEmails.contains(userEmail); // Check if the email is in the list
  }

  void onChangeSelectedHostel(String? hostel) =>
      selectedHostel = hostel?.getHostelFromDisplayString() ?? Hostel.none;

  void onChangeBreakfastPoints(String? points) =>
      breakfast = int.parse(points!);

  void onChangeLunchPoints(String? points) => lunch = int.parse(points!);

  void onChangeDinnerPoints(String? points) => dinner = int.parse(points!);

  void onChangeWasteDisposalPoints(String? points) =>
      wasteDisposal = int.parse(points!);

  void onChangePunctualityPoints(String? points) =>
      punctuality = int.parse(points!);

  void onChangeQualityPoints(String? points) => quality = int.parse(points!);

  void onChangeHygienePoints(String? points) => hygiene = int.parse(points!);

  void onSubmit() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (breakfast == 0 || lunch == 0 || dinner == 0) {
        showSnackBar("Please fill all the compulsory fields");
        return;
      }
      // Additional check for SMC members
      if (isSmcMember) {
        // Check if additional SMC-specific fields are filled
        if (wasteDisposal == 0 ||
            hygiene == 0 ||
            punctuality == 0 ||
            quality == 0) {
          showSnackBar("Please fill all the compulsory fields");
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      final data = {
        "comments": _commentsController.text.trim(),
        "hostel": selectedHostel.databaseString,
        "satisfaction": {
          "breakfast": breakfast,
          "lunch": lunch,
          "dinner": dinner,
        },
        "userName": user.name,
      };
      // Include additional fields if the user is an SMC member
      if (isSmcMember) {
        data["wasteDisposal"] = wasteDisposal;
        data["hygiene"] = hygiene;
        data["quality"] = quality;
        data["punctuality"] = punctuality;
      }
      final res = await MessStore().postMessOpi(data);
      if (res.containsKey('success')) {
        showSnackBar(res['message']);
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState!.pop();
      } else if (res.containsKey('errors')) {
        showSnackBar((res['errors'] as List<dynamic>).first['message']);
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState!.pop();
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      final error = e.toString();
      setState(() {
        isLoading = false;
      });
      if (error.contains('connection error')) {
        showSnackBar("No interest connection!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM').format(DateTime.now());
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: _buildAppBar(context),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const LinearProgressIndicator(
                    color: lBlue2,
                    backgroundColor: lBlue,
                  ),
                _buildInfo(user),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldTitle(
                          title:
                              "1. Which HOSTEL MESS did you subscribe to in $currentMonth?",
                          isNeccessary: true),
                      const SizedBox(height: 12),
                      CustomDropDown(
                        items: hostels.map((e) => e.displayString).toList(),
                        value: (user.hostel?.getHostelFromDatabaseString() ??
                                Hostel.none)
                            .displayString,
                        onChanged: onChangeSelectedHostel,
                        validator: validatefield,
                        borderRadius: BorderRadius.circular(24),
                        isNecessary: false,
                        icon: dropDownIcon,
                      ),
                      const SizedBox(height: 16),
                      _buildFieldTitle(
                          title:
                              "2. How would you rate the following services by the mess caterer",
                          isNeccessary: true),
                      const SizedBox(height: 16),
                      _pointsInfo(),
                      const SizedBox(height: 16),
                      if (isSmcMember) ...[
                        _buildFieldTitle(
                            title: "Waste Disposal", isNeccessary: true),
                        const SizedBox(height: 12),
                        CustomDropDown(
                          items: points.map((e) => e.toString()).toList(),
                          hintText: 'Points',
                          onChanged: onChangeWasteDisposalPoints,
                          validator: validatefield,
                          borderRadius: BorderRadius.circular(24),
                          isNecessary: false,
                          icon: dropDownIcon,
                        ),
                        const SizedBox(height: 16),
                        _buildFieldTitle(
                            title: "Uniform And Punctuality",
                            isNeccessary: true),
                        const SizedBox(height: 12),
                        CustomDropDown(
                          items: points.map((e) => e.toString()).toList(),
                          hintText: 'Points',
                          onChanged: onChangePunctualityPoints,
                          validator: validatefield,
                          borderRadius: BorderRadius.circular(24),
                          isNecessary: false,
                          icon: dropDownIcon,
                        ),
                        const SizedBox(height: 16),
                        _buildFieldTitle(
                            title: "Quality Of Ingredients",
                            isNeccessary: true),
                        const SizedBox(height: 12),
                        CustomDropDown(
                          items: points.map((e) => e.toString()).toList(),
                          hintText: 'Points',
                          onChanged: onChangeQualityPoints,
                          validator: validatefield,
                          borderRadius: BorderRadius.circular(24),
                          isNecessary: false,
                          icon: dropDownIcon,
                        ),
                        const SizedBox(height: 16),
                        _buildFieldTitle(
                            title: "Cleanliness And Hygiene",
                            isNeccessary: true),
                        const SizedBox(height: 12),
                        CustomDropDown(
                          items: points.map((e) => e.toString()).toList(),
                          hintText: 'Points',
                          onChanged: onChangeHygienePoints,
                          validator: validatefield,
                          borderRadius: BorderRadius.circular(24),
                          isNecessary: false,
                          icon: dropDownIcon,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildFieldTitle(
                          title: "Overall Satisfaction - Breakfast",
                          isNeccessary: true),
                      const SizedBox(height: 12),
                      CustomDropDown(
                        items: points.map((e) => e.toString()).toList(),
                        hintText: 'Points',
                        onChanged: onChangeBreakfastPoints,
                        validator: validatefield,
                        borderRadius: BorderRadius.circular(24),
                        isNecessary: false,
                        icon: dropDownIcon,
                      ),
                      const SizedBox(height: 16),
                      _buildFieldTitle(
                          title: "Overall Satisfaction - Lunch",
                          isNeccessary: true),
                      const SizedBox(height: 12),
                      CustomDropDown(
                        items: points.map((e) => e.toString()).toList(),
                        hintText: 'Points',
                        onChanged: onChangeLunchPoints,
                        validator: validatefield,
                        borderRadius: BorderRadius.circular(24),
                        isNecessary: false,
                        icon: dropDownIcon,
                      ),
                      const SizedBox(height: 16),
                      _buildFieldTitle(
                          title: "Overall Satisfaction - Dinner",
                          isNeccessary: true),
                      const SizedBox(height: 12),
                      CustomDropDown(
                        items: points.map((e) => e.toString()).toList(),
                        hintText: 'Points',
                        onChanged: onChangeDinnerPoints,
                        validator: validatefield,
                        borderRadius: BorderRadius.circular(24),
                        isNecessary: false,
                        icon: dropDownIcon,
                      ),
                      const SizedBox(height: 16),
                      _buildFieldTitle(
                          title: "Comments (if any)", isNeccessary: false),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _commentsController,
                        hintText: "Answer",
                        maxLines: 5,
                        isNecessary: false,
                      ),
                      const SizedBox(height: 24),
                      SimpleButton(
                        height: 60,
                        label: "Submit",
                        onTap: () => onSubmit(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pointsInfo() {
    final style =
        OnestopFonts.w600.size(14).setColor(kWhite).copyWith(height: 20 / 14);
    return Text(
      "Very Poor (1 Points)\nPoor (2 Points)\nAverage (3 Points)\nGood (4 Points)\nVery Good (5 Points)",
      style: style,
    );
  }

  RichText _buildFieldTitle(
      {required String title, required bool isNeccessary}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: OnestopFonts.w600.size(16).setColor(kWhite),
          ),
          if (isNeccessary)
            TextSpan(
              text: ' * ',
              style: OnestopFonts.w500.size(16).setColor(kRed),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kAppBarGrey,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: kAppBarGrey),
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: kWhite,
        ),
        iconSize: 20,
      ),
      title: Text(
        "Mess OPI Form",
        textAlign: TextAlign.left,
        style: OnestopFonts.w600.size(16).setColor(kWhite),
      ),
    );
  }

  Container _buildInfo(OneStopUser user) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kAppBarGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filling form as ${user.outlookEmail}",
            style: OnestopFonts.w500.size(11).setColor(kGrey10),
          ),
          const SizedBox(height: 16),
          Text(
            "This form is to be filled out by the mess subscribers of the hostels to provide assessment points to the mess catering service based on overall satisfaction with the food.",
            softWrap: true,
            style: OnestopFonts.w400
                .size(14)
                .setColor(kWhite)
                .copyWith(height: 20 / 14),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Fields marked with",
                  style: OnestopFonts.w500.size(11).setColor(kGrey10),
                ),
                TextSpan(
                  text: ' * ',
                  style: OnestopFonts.w500.size(14).setColor(kRed),
                ),
                TextSpan(
                  text: "are compulsory",
                  style: OnestopFonts.w500.size(11).setColor(kGrey10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
