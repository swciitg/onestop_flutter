import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/widgets/contact/contact_display.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contact_dialog.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contact_display.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../../../functions/utility/phone_email.dart';

class MedicalContactdetails extends StatefulWidget {
  final String title;
  final List<MedicalcontactModel> contacts;

  const MedicalContactdetails({Key? key, required this.contacts, required this.title})
      : super(key: key);

  @override
  State<MedicalContactdetails> createState() => _MedicalContactdetailsState();
}

class _MedicalContactdetailsState extends State<MedicalContactdetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          leading: Container(),
          leadingWidth: 0,
          title:
              Text('Contacts', style: MyFonts.w500.size(20).setColor(kWhite)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                FluentIcons.dismiss_24_filled,
                color: kWhite2,
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.title,
                    style: MyFonts.w600.size(16).setColor(kWhite),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2),
                  child: Text(
                    '${widget.contacts.length} contacts',
                    style: MyFonts.w500.size(12).setColor(kGrey11),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                MedicalContactDisplayHeader(
                    text: 'Name',
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    align: AlignmentDirectional.topStart),
                MedicalContactDisplayHeader(
                    text: 'Email id',
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    align: AlignmentDirectional.center),
                MedicalContactDisplayHeader(
                    text: 'Contact No ',
                    width: MediaQuery.of(context).size.width / 3 - 15,
                    align: AlignmentDirectional.bottomEnd),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.96,
              child: const Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.contacts.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => 
                                    MedicalContactDialog(contact: item),
                                  
                              barrierDismissible: true);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContactText(
                                text: item.name.name!,
                                align: AlignmentDirectional.topStart),
                            ContactText(
                                text: item.email!,
                                align: AlignmentDirectional.center),
                            ContactText(
                                text: "0361258${item.phone.toString()}",
                                align: AlignmentDirectional.bottomEnd),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}