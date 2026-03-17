import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onestop_ui/index.dart';

import '../../widgets/ui/list_shimmer.dart';

String _getProfileUrlByRoll(String rollNo) {
  return "https://online.iitg.ac.in/sprofile/GALLERY/20${rollNo.substring(0, 2)}/PHOTO/${rollNo}_P.jpg";
}

class VoterCard extends StatefulWidget {
  final String email;
  final String authCookie;

  const VoterCard({super.key, required this.email, required this.authCookie});

  @override
  State<VoterCard> createState() => _VoterCardState();
}

class _VoterCardState extends State<VoterCard> {
  Dio dio = Dio();

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

  String getBranch(String input) {
    for (var key in branches.keys) {
      if (branches[key] == input) return key;
    }
    return "Others";
  }

  String getDegree(String input) {
    for (var key in degrees.keys) {
      if (degrees[key] == input) return key;
    }
    return "B.Tech";
  }

  @override
  Widget build(BuildContext context) {
    dio.options.headers['cookie'] = widget.authCookie;
    dio
        .post(
          "https://swc.iitg.ac.in/elections_api/sgc/voting/get_eprofile/",
          data: {"email": widget.email},
        )
        .then((value) {});
    return FutureBuilder<Response>(
      future: dio.post(
        "https://swc.iitg.ac.in/elections_api/sgc/voting/get_eprofile/",
        data: {"email": widget.email},
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: ListShimmer(count: 1, height: 750));
        }
        var data = snapshot.data!.data;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(OSpacing.m),
          child: Column(
            children: [
              // ── Voter ID Card (matches profile _buildIdCard) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(OSpacing.m),
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
                  border: Border.all(color: OColor.green600),
                ),
                child: Column(
                  children: [
                    // IITG header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/iitg_logo.png', height: 40),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IITG GYMKHANA',
                              style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                            ),
                            Text(
                              'ELECTIONS 2026',
                              style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: OSpacing.s),
                    Divider(thickness: 1, color: OColor.gray200),
                    const SizedBox(height: OSpacing.s),

                    // Avatar – loaded from IITG profile URL
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: OColor.gray200,
                      child: ClipOval(
                        child: Image.network(
                          _getProfileUrlByRoll(data["roll_no"]),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, _, _) => Image.asset(
                                'assets/images/profile_placeholder.jpg',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: OSpacing.s),

                    // Name
                    OText(
                      text: data["name"],
                      style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: OSpacing.xxs),

                    // Roll number
                    OText(
                      text: data["roll_no"],
                      style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                    ),
                    const SizedBox(height: OSpacing.xxs),

                    // Voter ID subtitle
                    OText(
                      text: 'Voter ID',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.m),

                    // Barcode of roll number
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: data["roll_no"],
                      width: 200,
                      height: 60,
                      drawText: false,
                      color: OColor.black,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: OSpacing.m),

              // ── Details Card (matches profile _buildInfoSection) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(OSpacing.m),
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
                  border: Border.all(color: OColor.gray200),
                ),
                child: Column(
                  children: [
                    _infoTile('Degree', getDegree(data['degree'])),
                    Divider(color: OColor.gray200),
                    _infoTile(
                      'Hostel',
                      '${data['hostel'][0].toString().toUpperCase()}${data['hostel'].toString().substring(1)}',
                    ),
                    Divider(color: OColor.gray200),
                    _infoTile('Branch', getBranch(data['branch'])),
                    Divider(color: OColor.gray200),
                    _infoTile('Gender', data["gender"]),
                  ],
                ),
              ),
              const SizedBox(height: OSpacing.l),

              // SWC Logo
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 40,
                colorFilter: ColorFilter.mode(OColor.black, BlendMode.srcIn),
              ),
              const SizedBox(height: OSpacing.m),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: OTextStyle.labelMedium.copyWith(color: OColor.gray600)),
          Text(value, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
        ],
      ),
    );
  }
}
