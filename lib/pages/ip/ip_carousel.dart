import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/ip/ip_calculator.dart';
import 'package:onestop_dev/functions/ip/ip_decoration.dart';
import 'package:onestop_dev/pages/ip/ip_settings.dart';
import 'package:onestop_dev/widgets/ip/ip_input.dart';
import 'package:onestop_ui/index.dart';

List<String> textData = [
  'Open Start-> Control Panel -> Network and Internet-> Network and Sharing Center ',
  "Click on 'Manage wireless networks'",
  'Right click on \'Local area connection\' and then click on properties',
  'Uncheck \'Internet Protocol Version 6 (TCP/IPv6)\' and double click \'Internet Protocol Version 4 (TCP/IPv4)\'',
  'Select \'Use the following IP address\' and \'Use the following DNS server addresses\' Modify the DNS address as given below\nprimary DNS: 172.17.1.1\nsecondary DNS: 172.17.1.2',
  'Enter the following details to get your IP address',
  '',
  "Make sure the connection is no-proxy/direct connection. Open any website in your browser. It will show a captive portal asking your IITG login credentials.Login to the portal and start accessing internet using the same.If you have a problem while redirecting to login page, then use this link given below in your pc browser https://agnigarh.iitg.ac.in:1442/login?",
  'You might need to change some of your laptop settings before you could start using the internet in your room. Go through the following steps after connecting your laptop to the LAN port. ',
];
bool fg = true;

class RouterPage extends StatefulWidget {
  static const String id = "/ip";

  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int page = 1;
  Widget seven = const Column();
  final buttonCarouselController = CarouselSliderController();
  TextEditingController roomController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  HostelDetails hostel = HostelDetails("nothing", "--", "--=-=-===", "something");
  String dropdownValue = "Select Hostel";
  List<String> spinnerItems = [
    'Select Hostel',
    'Barak',
    'Umiam',
    'Brahmaputra',
    'Manas',
    'Dihing',
    'Dibang',
    'Married Scholars',
    'Siang',
    'Dhansiri',
    'Subhansiri',
    'Kapili',
    'Kameng',
  ];
  final _keyform = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      page = 1;
    });
  }

  void function(HostelDetails argso) {
    setState(() {
      seven = IpPage(argso: argso);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: OColor.white,
      appBar: AppBar(
        backgroundColor: OColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Internet Settings',
          style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Intro text
              Padding(
                padding: const EdgeInsets.all(OSpacing.m),
                child: Text(
                  textData[8],
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                ),
              ),

              // Step indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: _StepIndicator(current: page, total: 8),
              ),
              const SizedBox(height: OSpacing.m),

              // Card container
              Container(
                alignment: Alignment.topCenter,
                width: width - OSpacing.m * 2,
                decoration: BoxDecoration(
                  color: OColor.white,
                  border: Border.all(color: OColor.gray200),
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    OSpacing.m,
                    OSpacing.l,
                    OSpacing.m,
                    OSpacing.s,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 445,
                        child: CarouselSlider(
                          items:
                              [1, 2, 3, 4, 5, 6, 7, 8].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // Step title
                                        Text(
                                          'Step $i of 8',
                                          style: OTextStyle.headingSmall.copyWith(
                                            color: OColor.gray800,
                                          ),
                                        ),
                                        const SizedBox(height: OSpacing.xs),
                                        // Step description
                                        Text(
                                          textData[i - 1],
                                          style: OTextStyle.bodySmall.copyWith(
                                            color: OColor.gray500,
                                          ),
                                        ),
                                        const SizedBox(height: OSpacing.xs),
                                        // Content per step
                                        _buildStepContent(i, context),
                                      ],
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
                            enlargeCenterPage: true,
                            viewportFraction: 0.95,
                            height: 445,
                            initialPage: 0,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ),

                      // Navigation buttons
                      Padding(
                        padding: const EdgeInsets.only(top: OSpacing.xs, bottom: OSpacing.xs),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavButton(
                              icon: FluentIcons.chevron_left_24_regular,
                              label: 'Back',
                              enabled: page != 1,
                              onTap: () async {
                                if (page != 1) {
                                  if (page == 6) {
                                    setState(() {
                                      seven = const Column();
                                    });
                                  }
                                  await buttonCarouselController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                }
                              },
                            ),
                            _NavButton(
                              icon: FluentIcons.chevron_right_24_regular,
                              label: 'Next',
                              enabled: page != 8,
                              iconRight: true,
                              onTap: () async {
                                if (page < 8 && page != 6) {
                                  await buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                } else if (page == 6) {
                                  if (dropdownValue != 'Select Hostel') {
                                    if (_keyform.currentState!.validate()) {
                                      function(hostel);
                                      fg = false;
                                      await buttonCarouselController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: OSpacing.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int i, BuildContext context) {
    if (i == 6) {
      return Form(
        key: _keyform,
        child: Column(
          children: [
            const SizedBox(height: OSpacing.m),
            DropdownButtonFormField<String>(
              initialValue: dropdownValue,
              icon: Icon(Icons.arrow_drop_down, color: OColor.gray500),
              dropdownColor: OColor.white,
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
              onChanged: (data) {
                setState(() {
                  dropdownValue = data!;
                  hostel.hostelName = dropdownValue;
                });
              },
              decoration: ipInputDecoration('Select Hostel'),
              items:
                  spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: OSpacing.s),
            IpField(
              texta: "Remember your room number correctly",
              textb: 'Room Number',
              hostel: hostel,
              control: roomController,
            ),
            const SizedBox(height: OSpacing.s),
            IpField(
              texta: "remember your block number correctly",
              textb: 'Block',
              hostel: hostel,
              control: blockController,
            ),
            const SizedBox(height: OSpacing.s),
            IpField(
              texta: "remember your floor number correctly",
              textb: 'Floor',
              hostel: hostel,
              control: floorController,
            ),
          ],
        ),
      );
    } else if (i == 7) {
      return seven;
    } else if (i == 5) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(OCornerRadius.s),
          child: Image.asset('assets/images/lan5.png', height: 260, fit: BoxFit.cover),
        ),
      );
    } else if (i == 4) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        child: Image.asset('assets/images/lan4.png', height: 290),
      );
    } else if (i != 8) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        child: Image.asset('assets/images/lan$i.png'),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

/// Horizontal step indicator dots
class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index + 1 == current;
        final isCompleted = index + 1 < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                isActive
                    ? OColor.green600
                    : isCompleted
                    ? OColor.green300
                    : OColor.gray200,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Navigation button (Back / Next) used at bottom of card
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool iconRight;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    this.iconRight = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? OColor.green600 : OColor.gray300;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(color: enabled ? OColor.gray300 : OColor.gray200),
          borderRadius: BorderRadius.circular(OCornerRadius.l),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!iconRight) Icon(icon, size: 18, color: color),
            if (!iconRight) const SizedBox(width: OSpacing.xxs),
            Text(label, style: OTextStyle.labelSmall.copyWith(color: color)),
            if (iconRight) const SizedBox(width: OSpacing.xxs),
            if (iconRight) Icon(icon, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}