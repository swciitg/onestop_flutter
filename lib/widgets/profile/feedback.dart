import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:provider/provider.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  String selected = 'Issue Report';
  bool enableSubmitButton = true;
  Widget? counterBuilder(context,
      {required currentLength, required isFocused, required maxLength}) {
    if (currentLength == 0) {
      return null;
    }
    return Text("$currentLength/$maxLength",
        style: MyFonts.w500.size(12).setColor(kWhite));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            color: kBackground,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Text(
                        'Type',
                        style: MyFonts.w500.setColor(kWhite).size(15),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = "Issue Report";
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: (selected == "Issue Report")
                                    ? lBlue2
                                    : kGrey9,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Issue Report',
                                style: (selected == "Issue Report")
                                    ? MyFonts.w500.size(13).setColor(kBlueGrey)
                                    : MyFonts.w500.size(13).setColor(
                                        const Color.fromRGBO(91, 146, 227, 1)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = "Feature Request";
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: (selected == "Feature Request")
                                    ? lBlue2
                                    : kGrey9,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Feature Request',
                                style: (selected == "Feature Request")
                                    ? MyFonts.w500.size(13).setColor(kBlueGrey)
                                    : MyFonts.w500.size(13).setColor(
                                        const Color.fromRGBO(91, 146, 227, 1)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Title',
                        style: MyFonts.w500.setColor(kWhite).size(15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        style: MyFonts.w500.size(15).setColor(kWhite),
                        controller: title,
                        maxLength: 25,
                        maxLines: 1,
                        buildCounter: counterBuilder,
                        decoration: InputDecoration(
                          errorStyle: MyFonts.w400.size(12).setColor(kRed),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          fillColor: kAppBarGrey,
                          filled: true,
                          hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        ),
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Body',
                        style: MyFonts.w500.setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        style: MyFonts.w500.size(15).setColor(kWhite),
                        controller: body,
                        maxLength: 150,
                        maxLines: 4,
                        buildCounter: counterBuilder,
                        decoration: InputDecoration(
                          errorStyle: MyFonts.w400.size(12).setColor(kRed),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          fillColor: kAppBarGrey,
                          filled: true,
                          hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        ),
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: !enableSubmitButton
                          ? null
                          : () async {
                              bool isValid = formKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                              Map<String, String> data = {
                                'title': title.text,
                                'body': body.text,
                                'type': selected,
                                'user': context
                                        .read<LoginStore>()
                                        .userData['email'] ??
                                    "Unknown"
                              };
                              setState(() => enableSubmitButton = false);
                              bool success =
                                  await APIService.postFeedbackData(data);
                              String snackBar =
                                  "There was an error while sending your feedback.\nPlease try again later or reach out to any member using the Contacts section.";
                              if (success) {
                                snackBar =
                                    "Your feedback was successfully shared to SWC.\nKeep an eye for updates as developers will start working on this shortly.";
                              }
                              if (mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                              rootScaffoldMessengerKey.currentState
                                  ?.showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 8),
                                      content: Text(
                                        snackBar,
                                        style: MyFonts.w500,
                                      )));
                            },
                      child: const NextButton(
                        title: 'Submit',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
