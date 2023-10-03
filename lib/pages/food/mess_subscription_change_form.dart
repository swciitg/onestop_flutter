import 'package:flutter/material.dart';
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

class MessSubscriptionPage extends StatefulWidget {
  static const id = '/messSubscriptionPage';
  const MessSubscriptionPage({super.key});

  @override
  State<MessSubscriptionPage> createState() => _MessSubscriptionPageState();
}

class _MessSubscriptionPageState extends State<MessSubscriptionPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final user = ProfileModel.fromJson(LoginStore.userData);
  final List<String> hostels = khostels;
  bool isLoading = false;
  late String currentHostel;
  late String desiredHostel;

  void onChangeCurrentHostel(String? hostel) => currentHostel = hostel!;
  void onChangeDesiredHostel(String? hostel) => desiredHostel = hostel!;

  @override
  void initState() {
    currentHostel = user.hostel ?? hostels.first;
    desiredHostel = hostels.first;
    _phoneController.text = user.phoneNumber?.toString() ?? "your answer";
    _rollNumberController.text = user.rollNo;
    super.initState();
  }

  void onPressedSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (_phoneController.text.length < 10) {
      showSnackBar("Provide proper contact number");
    } else if (_rollNumberController.text != user.rollNo) {
      showSnackBar("Incorrect Roll Number");
    }
    print("Contact number: ${_phoneController.text}");
    print("Roll no: ${_rollNumberController.text}");
    print("current hostel: ${user.hostel}");
    print("desired hostel: $desiredHostel");
    // TODO: implemting submit action once form is submitted
    // to check loading bar
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentHostel = user.hostel ?? hostels.first;
    desiredHostel = hostels.first;

    final dropDownIcon = const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 24,
      color: kWhite,
    );

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
                        title: "Contact Number", isNeccessary: true),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Your answer",
                      inputType: TextInputType.phone,
                      isNecessary: false,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldTitle(title: "Roll Number", isNeccessary: true),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _rollNumberController,
                      hintText: user.rollNo,
                      inputType: TextInputType.number,
                      isNecessary: false,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldTitle(
                        title: "Hostel (Currently residing)",
                        isNeccessary: true),
                    const SizedBox(height: 12),
                    CustomDropDown(
                      items: hostels,
                      hintText: user.hostel ?? hostels.first,
                      value: user.hostel,
                      onChanged: onChangeCurrentHostel,
                      validator: validatefield,
                      borderRadius: BorderRadius.circular(24),
                      isNecessary: false,
                      icon: dropDownIcon,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldTitle(
                        title:
                            "In which hostel mess do you want your subscription to be changed:",
                        isNeccessary: true),
                    const SizedBox(height: 12),
                    CustomDropDown(
                      items: hostels,
                      hintText: hostels.first,
                      value: hostels.first,
                      onChanged: onChangeDesiredHostel,
                      validator: validatefield,
                      borderRadius: BorderRadius.circular(24),
                      isNecessary: false,
                      icon: dropDownIcon,
                    ),
                    const SizedBox(height: 16),
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
            label: "Submit",
            onTap: onPressedSubmit,
          ),
        ),
      ),
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
        "Mess Subscription Change Form",
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
            "Please submit the form ONLY if you want to change your mess subscription to another hostel. Your subscription of all the meals for the aforementioned month will be changed to the chosen hostel.",
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
