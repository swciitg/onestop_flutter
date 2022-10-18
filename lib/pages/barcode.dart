// ignore_for_file: unused_import

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRPage extends StatefulWidget {
  static String id = "/qr";

  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                  width: MediaQuery.of(context).size.width,
                ),
                Text(
                  "${context.read<LoginStore>().userData['name']}",
                  textAlign: TextAlign.center,
                  style: MyFonts.w800.setColor(kWhite).size(20),
                ),
                Text(
                  '${context.read<LoginStore>().userData['rollno']}',
                  textAlign: TextAlign.center,
                  style: MyFonts.w500.setColor(kWhite).size(20),
                ),
                const HostelSelector(),
                const SizedBox(
                  height: 26,
                ),
                // Stack(
                //   children: [
                //     Container(
                //       height: 300,
                //       width: double.infinity,
                //       color: kWhite,
                //     ),
                //     Positioned.fill(
                //       child: Align(
                //         alignment: Alignment.center,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 16),
                //           child: BarcodeWidget(
                //             barcode: Barcode.code128(),
                //             data: "${context.read<LoginStore>().userData['rollno']}",
                //             height: 150,
                //             color: kBlack,
                //             backgroundColor: kWhite,
                //             drawText: false,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Center(
                //     child: Text(
                //       "Library issuing barcode",
                //       textAlign: TextAlign.center,
                //       style: MyFonts.w500.setColor(kWhite).size(18),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginStore>().logOut(() =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false));
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0, primary: kAppBarGrey),
                      child: Text(
                        'Log Out',
                        style: MyFonts.w500.setColor(kBlue),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HostelSelector extends StatefulWidget {
  const HostelSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<HostelSelector> createState() => _HostelSelectorState();
}

class _HostelSelectorState extends State<HostelSelector> {
  final List<String> hostels = [
    "Kameng",
    "Barak",
    "Lohit",
    "Brahma",
    "Disang",
    "Manas",
    "Dihing",
    "Umiam",
    "Siang",
    "Kapili",
    "Dhansiri",
    "Subhansiri"
  ];

  Future<String> getSavedHostel() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('hostel')) {
      return prefs.getString('hostel')??"Brahma";
    }
    return "No hostel selected";
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getSavedHostel(),
      builder: (context,snapshot) {
        if (!snapshot.hasData){
          return Container(
            height: 25,
          );
        }
        return Theme(
          data: Theme.of(context)
              .copyWith(cardColor: kBlueGrey),
          child: PopupMenuButton<String>(
            offset: const Offset(0,30),
            itemBuilder: (context) {
              return hostels
                  .map(
                    (value) => PopupMenuItem(
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString('hostel', value);
                    setState((){});
                  },
                  value: value,
                  child: Text(
                    value,
                    style: MyFonts.w500
                        .setColor(kWhite),
                  ),
                ),
              )
                  .toList();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                  style: MyFonts.w500.setColor(kWhite).size(15),
                ),
                const SizedBox(width: 10,),
                const Icon(
                  FluentIcons.chevron_down_12_regular,
                  color: lBlue,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
