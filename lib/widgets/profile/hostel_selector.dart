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

  Future<dynamic> getSavedHostel() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('hostel')) {
      return prefs.getString('hostel');
    }
    return null;
  }

  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getSavedHostel(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return Container(
          //     height: 25,
          //   );
          // }
          return Theme(
              data: Theme.of(context).copyWith(canvasColor: kBlueGrey),
              child: DropdownButton<String>(
                value: snapshot.data,
                hint: Text('Select Hostel ', style: MyFonts.w500.setColor(kWhite).size(15),),
                underline: Container(),
                icon: const Icon(
                  FluentIcons.chevron_down_12_regular,
                  color: lBlue,
                ),
                iconSize: 13,
                menuMaxHeight: 250,
                onChanged: (String? value) async {
                  // This is called when the user selects an item.
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString('hostel', value!);
                  setState(() {
                    dropdownValue = value;
                  });
                },
                items: hostels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: MyFonts.w500.setColor(kWhite).size(15),
                    ),
                  );
                }).toList(),
              ));
        });
  }
}
