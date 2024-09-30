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
                          _showContactInfoDialog(context,item);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ContactText(
                                text: item.name,
                                align: AlignmentDirectional.topStart),
                            ContactText(
                                text: item.email,
                                align: AlignmentDirectional.center),
                            ContactText(
                                text: "0361258${item.contact.toString()}",
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


void _showContactInfoDialog(BuildContext context, MedicalcontactModel contact) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900], // Dark background
        content: Container(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),

                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10,),
                _buildInfoRow(Icons.work, contact.designation),
                _buildInfoRow(Icons.school, contact.degree),
                _buildInfoRow(Icons.phone, "0361258${contact.contact}"),
                _buildInfoRow(Icons.email, contact.email),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () async {
                    try {
                      await launchPhoneURL(contact.contact);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }

                  }, icon: const Icon(Icons.call, color: Colors.green),),
                  IconButton(onPressed: () async {
                    try {
                      await launchEmailURL(contact.email);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }, icon: const Icon(Icons.mail, color: Colors.blue),),
                ],
              ),
              TextButton(
                child: const Text("Close", style: TextStyle(color: Colors.white70)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildInfoRow(IconData icon, String info) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20), // Icon only
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            info,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}