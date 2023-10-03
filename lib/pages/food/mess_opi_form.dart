import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/functions/utility/validator.dart';
import 'package:onestop_dev/globals/hostels.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/profile/profile_model.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/profile/custom_dropdown.dart';
import 'package:onestop_dev/widgets/profile/custom_text_field.dart';
import 'package:onestop_dev/widgets/ui/simple_button.dart';

class MessOpiFormPage extends StatefulWidget {
  static const id = '/messOpiFormPage';
  const MessOpiFormPage({super.key});

  @override
  State<MessOpiFormPage> createState() => _MessOpiFormPageState();
}

class _MessOpiFormPageState extends State<MessOpiFormPage> {
  final TextEditingController _commentsController = TextEditingController();
  final user = ProfileModel.fromJson(LoginStore.userData);
  late String selectedHostel;
  int breakFastPoints = 0;
  int lunchPoints = 0;
  int dinnerPoints = 0;
  bool isLoading = false;
  final List<String> hostels = khostels;
  final List<int> points = [1, 2, 3, 4, 5];
  final dropDownIcon = const Icon(
    Icons.keyboard_arrow_down_rounded,
    size: 24,
    color: kWhite,
  );

  @override
  void initState() {
    selectedHostel = user.hostel ?? hostels.first;
    super.initState();
  }

  void onChangeSelectedHostel(String? hostel) => selectedHostel = hostel!;
  void onChangeBreakfastPoints(String? points) =>
      breakFastPoints = int.parse(points!);
  void onChangeLunchPoints(String? points) => lunchPoints = int.parse(points!);
  void onChangeDinnerPoints(String? points) =>
      dinnerPoints = int.parse(points!);

  void onPressedNext() async {
    setState(() {
      isLoading = true;
    });
    print("Breakfast points: $breakFastPoints");
    print("Lunch points: $lunchPoints");
    print("Dinner points: $dinnerPoints");
    print("Comments: ${_commentsController.text}");
    if (breakFastPoints == 0 || lunchPoints == 0 || dinnerPoints == 0) {
      print("user not assigned all fields");
      showSnackBar("Please fill all the compulsory fields");
    }
    // TODO: implement any further actions
    // just to check loading bar
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('MMMM').format(DateTime.now());
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                      items: hostels,
                      hintText: user.hostel ?? hostels.first,
                      value: user.hostel,
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
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 0),
          child: SimpleButton(
            height: 60,
            label: "Next",
            onTap: onPressedNext,
          ),
        ),
      ),
    );
  }

  Column _pointsInfo() {
    final style =
        MyFonts.w600.size(14).setColor(kWhite).copyWith(height: 20 / 14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Very Poor (1 Points)", style: style),
        Text("Poor (2 Points)", style: style),
        Text("Average (3 Points)", style: style),
        Text("Good (4 Points)", style: style),
        Text("Very Good (5 Points)", style: style),
      ],
    );
  }

  RichText _buildFieldTitle(
      {required String title, required bool isNeccessary}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: MyFonts.w600.size(16).setColor(kWhite),
          ),
          if (isNeccessary)
            TextSpan(
              text: ' * ',
              style: MyFonts.w500.size(16).setColor(kRed),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kAppBarGrey,
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
        style: MyFonts.w600.size(16).setColor(kWhite),
      ),
    );
  }

  Container _buildInfo(ProfileModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kAppBarGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filling form as ${user.outlookEmail}",
            style: MyFonts.w500.size(11).setColor(kGrey10),
          ),
          const SizedBox(height: 16),
          Text(
            "This form is to be filled out by the mess subscribers of the hostels to provide assessment points to the mess catering service based on overall satisfaction with the food.",
            softWrap: true,
            style: MyFonts.w400
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
                  style: MyFonts.w500.size(11).setColor(kGrey10),
                ),
                TextSpan(
                  text: ' * ',
                  style: MyFonts.w500.size(14).setColor(kRed),
                ),
                TextSpan(
                  text: "are compulsory",
                  style: MyFonts.w500.size(11).setColor(kGrey10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
