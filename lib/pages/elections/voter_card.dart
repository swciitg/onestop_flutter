import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

import '../../widgets/ui/list_shimmer.dart';

class VoterCard extends StatefulWidget {
  final String email;
  final String authCookie;

  const VoterCard({Key? key, required this.email, required this.authCookie})
      : super(key: key);

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
    "Others": "Others"
  };

  String getBranch(String input) {
    String answer = "Others";
    for (var key in branches.keys) {
      if (branches[key] == input) {
        return key;
      }
    }
    return answer;
  }

  String getDegree(String input) {
    String answer = "B.Tech";
    for (var key in degrees.keys) {
      if (degrees[key] == input) {
        return key;
      }
    }
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    dio.options.headers['cookie'] =
        widget.authCookie; // setting cookies for auth
    dio.post("https://swc.iitg.ac.in/elections_api/sgc/voting/get_eprofile/",
        data: {"email": widget.email}).then((value) {
      //print(value);
    });
    return FutureBuilder<Response>(
        future: dio.post(
            "https://swc.iitg.ac.in/elections_api/sgc/voting/get_eprofile/",
            data: {"email": widget.email}),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
                child: ListShimmer(
              count: 1,
              height: 750,
            ));
          }
          //print(snapshot.data!);
          var data = snapshot.data!.data;
          //print(data);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "IITG GYMKHANA ELECTIONS 2024",
                                    style:
                                        MyFonts.w700.setColor(kWhite).size(25),
                                    textAlign: TextAlign.center,
                                  ))),
                        ],
                      ),
                      Text(
                        "Voter ID",
                        style: MyFonts.w500.setColor(kWhite).size(25),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: data["img_url"],
                          placeholder: (context, url) => ListShimmer(
                            count: 1,
                            height: 200,
                          ),
                          errorWidget: (context, url, error) => const Image(
                              image: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg')),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //Image.network('src'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Name: ${data["name"]}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Roll no: ${data["roll_no"]}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Degree: ${getDegree(data['degree'])}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hostel: ${data['hostel'][0].toString().toUpperCase()}${data['hostel'].toString().substring(1)}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Branch: ${getBranch(data['branch'])}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Gender: ${data["gender"]}",
                          style: MyFonts.w500.setColor(kWhite).size(18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: 55,
                  child: Image.asset(
                    'assets/images/logoo.png',
                    cacheWidth: 451,
                    cacheHeight: 75,
                  )),
              const SizedBox(
                height: 15,
              )
            ],
          );
        });
  }
}
