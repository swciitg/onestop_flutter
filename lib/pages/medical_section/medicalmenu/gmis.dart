import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../globals/my_colors.dart';
import '../../../globals/my_fonts.dart';

class Gmis extends StatefulWidget {
  const Gmis({super.key});

  @override
  State<Gmis> createState() => _GmisState();
}


class _GmisState extends State<Gmis> {
  int page=1;
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
      appBar: _buildAppBar(context),
      backgroundColor: OneStopColors.backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text(
                      "Follow the steps below to successfully download your GMIS card and enjoy the benefits it offers.",
                      style: MyFonts.w600.size(14).setColor(kGrey8),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 520,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                        color: kAppBarGrey,
                        border: Border.all(),
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: [1, 2, 3].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(height: 5,),
                                        _CarsoulWidgets[i-1],

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
                                    page = index + 1; //<-- Page index
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
                                        curve: Curves.linear);
                                  }
                                },
                                icon: Icon(
                                  FluentIcons.chevron_left_24_regular,
                                  color: page != 1 ? kWhite2 : kGrey7,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if(page!=3){
                                    await buttonCarouselController.nextPage(
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.linear);
                                  }

                                },
                                icon: Icon(
                                  FluentIcons.chevron_right_24_regular,
                                  color: page != 3 ? kWhite2 : kGrey7,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}


List<Widget> _CarsoulWidgets=[widg1, widg2, widg3];

Widget widg1 = Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Step 1 Title
    Text(
      "Step 1: Go to the following link:",
      style: MyFonts.w500.setColor(kWhite).size(16).copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),

    // Medi Assist Portal Link with Tap Gesture
    Text.rich(
      TextSpan(
        text: "Link: ", // Normal text
        style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
        children: <TextSpan>[
          TextSpan(
            text: 'Medi Assist Portal', // Clickable Text
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              decoration: TextDecoration.underline, // Underline to show it's a clickable link
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Launch the portal URL when tapped
                _launchURL("https://portal.mediassist.in/login.aspx");
              },
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),

    // Instruction after clicking the link
    Text(
      "After clicking the link, you will be redirected to the login page where you can proceed with further steps.",
      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
    ),
  ],
);

Widget widg2 = Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Step 2 Title
    Text(
      "Step 2: Enter Your Username and Password:",
      style: MyFonts.w500.setColor(kWhite).size(16).copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),

    // Username Section
    Text(
      "Username:",
      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),

    // Username Format
    Text.rich(
      TextSpan(
        text: "Format: ",
        style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
        children: const <TextSpan>[
          TextSpan(
            text: "MA<Roll No>IITG@iitg.ac.in",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    ),
    const SizedBox(height: 4),

    // Example for Username
    Text(
      "Example: For Roll No 176141009, Username will be:",
      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
    ),
    const SizedBox(height: 4),

    // Example Username
    const Text(
      "MA176141009IITG@iitg.ac.in",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    ),
    const SizedBox(height: 16),

    // Password Section
    Text(
      "Password:",
      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),

    // Password Format
    Text(
      "Use your Date of Birth in the DD-MM-YYYY format.",
      style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
    ),
    const SizedBox(height: 8),

    // Example for Password
    Text.rich(
      TextSpan(
        text: "Example: For Date of Birth 1st July 1985, the password will be: ",
        style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
        children: const <TextSpan>[
          TextSpan(
            text: "01-07-1985.",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),

    Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          "Note on Password:",
          style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "If you changed your password during the last policy year, use the updated password for login.",
              style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    ),

    // ExpansionTile for "First Login - Change Password"
    Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          "First Login - Change Password:",
          style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "After your first login, you will be prompted to change your password.",
              style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    ),

    // ExpansionTile for "Register Mobile Number and Email"
    Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          "Register Mobile Number and Email:",
          style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "You will then be required to register your mobile number and email ID in the portal.",
              style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    ),
  ],
);

Widget widg3 = Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Step 2 Title
    Text(
      "Step 3: Download E-Card:",
      style: MyFonts.w500.setColor(kWhite).size(16).copyWith(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),

    // Instruction Text with Bold and Normal Text
    Text.rich(
      TextSpan(
        text: "Once you are redirected to the homepage, go to the ", // Normal text
        style: MyFonts.w500.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w300),
        children: <TextSpan>[
          const TextSpan(
            text: "Policy Tab", // Bold text for 'Policy Tab'
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: " and select the "), // Normal text
          const TextSpan(
            text: "Download E-Card", // Bold text for 'Download E-Card'
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: " option."), // Normal text
        ],
      ),
    ),
    const SizedBox(height: 16),
  ],
);




Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);  // Use Uri.parse to handle the full URL
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Cannot launch URL";
  }
}


AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "GMIS card",
      textAlign: TextAlign.center,
      style: OnestopFonts.w500.size(20).setColor(kWhite),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.clear,
          color: kWhite,
        ),
      ),
    ],
  );
}
