import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return prefs.getString('hostel')??"Kameng";
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
              position: PopupMenuPosition.under,
              offset: const Offset(0.0,0),
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