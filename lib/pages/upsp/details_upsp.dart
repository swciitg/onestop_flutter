import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';


class DetailsUpsp extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailsUpsp({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailsUpsp> createState() => _DetailsUpspState();
}

class _DetailsUpspState extends State<DetailsUpsp> {
  String selectedDropdown = 'Kameng';
  TextEditingController contact = TextEditingController();
  List<String> hostels = [
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
          "2. Your Details",
          style: MyFonts.w600.size(16).setColor(kWhite),
        ),
      ),
      body: Column(
        children: [
          const ProgressBar(blue: 2, grey: 0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                    child: Text(
                      "Contact Number",
                      style: MyFonts.w600.size(16).setColor(kWhite),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: kGrey2),
                            color: kBackground, borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: contact,
                              style: MyFonts.w500.size(16).setColor(kWhite),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Your Answer',
                                hintStyle: TextStyle(color: kGrey8),
                              ),
                            )
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                    child: Text(
                      "Your Hostel",
                      style: MyFonts.w600.size(16).setColor(kWhite),
                    ),
                  ),

                  Theme(
                    data: Theme.of(context).copyWith(canvasColor: kBlueGrey),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      child: DropdownButtonFormField<String>(
                        value: selectedDropdown,
                        icon: const Icon(
                          FluentIcons.chevron_down_24_regular,
                          color: kWhite,
                        ),
                        style: MyFonts.w600.size(14).setColor(kWhite),
                        onChanged: (data) {
                          setState(() {
                            selectedDropdown = data!;
                          });
                        },
                        items: hostels.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                value,
                                style: MyFonts.w600.size(14).setColor(kWhite),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> data = widget.data;
                      data['phone'] = contact.text;
                      data['hostel'] = selectedDropdown;
                      print(data);
                      try
                      {
                        var response = await APIService.postUPSP(data);
                        if (!mounted) return;
                        if(response['success'])
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Problem posted successfully",
                                  style: MyFonts.w500,
                                )));
                            Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Some error occured, please try again",
                                  style: MyFonts.w500,
                                )));
                          }
                      }
                      catch(err){
                        print(err);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Please check you internet connection and try again",
                              style: MyFonts.w500,
                            )));
                      }

                    },
                    child: const NextButton(
                      title: "Submit",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
