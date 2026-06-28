import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

class Gmis extends StatefulWidget {
  const Gmis({super.key});

  @override
  State<Gmis> createState() => _GmisState();
}

class _GmisState extends State<Gmis> {
  int page = 1;
  final buttonCarouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    setState(() {
      page = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('GMIS Card', style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(OSpacing.m),
                  child: Text(
                    "Follow the steps below to successfully download your GMIS card and enjoy the benefits it offers.",
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  height: 520,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: OColor.white,
                    border: Border.all(color: OColor.gray200),
                    borderRadius: BorderRadius.circular(OCornerRadius.l),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(OSpacing.m, OSpacing.l, OSpacing.m, 0),
                    child: Column(
                      children: [
                        CarouselSlider(
                          items:
                              [1, 2, 3].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const SizedBox(height: 5),
                                          _carouselWidgets[i - 1],
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                page = index + 1;
                              });
                            },
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.horizontal,
                            enlargeCenterPage: true,
                            viewportFraction: 0.95,
                            height: 445,
                            initialPage: 0,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (page != 1) {
                                  await buttonCarouselController.previousPage(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.linear,
                                  );
                                }
                              },
                              icon: Icon(
                                FluentIcons.chevron_left_24_regular,
                                color: page != 1 ? OColor.green600 : OColor.gray300,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (page != 3) {
                                  await buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.linear,
                                  );
                                }
                              },
                              icon: Icon(
                                FluentIcons.chevron_right_24_regular,
                                color: page != 3 ? OColor.green600 : OColor.gray300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: OSpacing.s),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _carouselWidgets = [_widg1, _widg2, _widg3];

Widget _widg1 = Builder(
  builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 1: Go to the following link:",
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        Text.rich(
          TextSpan(
            text: "Link: ",
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
            children: <TextSpan>[
              TextSpan(
                text: 'Medi Assist Portal',
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.blue500,
                  decoration: TextDecoration.underline,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL("https://portal.mediassist.in/login.aspx");
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: OSpacing.m),
        Text(
          "After clicking the link, you will be redirected to the login page where you can proceed with further steps.",
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
        ),
      ],
    );
  },
);

Widget _widg2 = Builder(
  builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 2: Enter Your Username and Password:",
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        Text("Username:", style: OTextStyle.labelSmall.copyWith(color: OColor.gray800)),
        const SizedBox(height: OSpacing.xs),
        Text.rich(
          TextSpan(
            text: "Format: ",
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
            children: <TextSpan>[
              TextSpan(
                text: "MA<Roll No>IITG@iitg.ac.in",
                style: OTextStyle.labelSmall.copyWith(color: OColor.blue500),
              ),
            ],
          ),
        ),
        const SizedBox(height: OSpacing.xxs),
        Text(
          "Example: For Roll No 176141009, Username will be:",
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
        ),
        const SizedBox(height: OSpacing.xxs),
        Text(
          "MA176141009IITG@iitg.ac.in",
          style: OTextStyle.labelSmall.copyWith(color: OColor.blue500),
        ),
        const SizedBox(height: OSpacing.m),
        Text("Password:", style: OTextStyle.labelSmall.copyWith(color: OColor.gray800)),
        const SizedBox(height: OSpacing.xs),
        Text(
          "Use your Date of Birth in the DD-MM-YYYY format.",
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
        ),
        const SizedBox(height: OSpacing.xs),
        Text.rich(
          TextSpan(
            text: "Example: For Date of Birth 1st July 1985, the password will be: ",
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
            children: <TextSpan>[
              TextSpan(
                text: "01-07-1985.",
                style: OTextStyle.labelSmall.copyWith(color: OColor.blue500),
              ),
            ],
          ),
        ),
        const SizedBox(height: OSpacing.m),
        Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              "Note on Password:",
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: Text(
                  "If you changed your password during the last policy year, use the updated password for login.",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                ),
              ),
            ],
          ),
        ),
        Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              "First Login - Change Password:",
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: Text(
                  "After your first login, you will be prompted to change your password.",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                ),
              ),
            ],
          ),
        ),
        Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              "Register Mobile Number and Email:",
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: Text(
                  "You will then be required to register your mobile number and email ID in the portal.",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  },
);

Widget _widg3 = Builder(
  builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 3: Download E-Card:",
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
        ),
        const SizedBox(height: OSpacing.xs),
        Text.rich(
          TextSpan(
            text: "Once you are redirected to the homepage, go to the ",
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
            children: <TextSpan>[
              TextSpan(
                text: "Policy Tab",
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
              ),
              const TextSpan(text: " and select the "),
              TextSpan(
                text: "Download E-Card",
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
              ),
              const TextSpan(text: " option."),
            ],
          ),
        ),
        const SizedBox(height: OSpacing.m),
      ],
    );
  },
);

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Cannot launch URL";
  }
}
