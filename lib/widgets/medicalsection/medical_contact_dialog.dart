import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MedicalContactDialog extends StatefulWidget {
  final MedicalcontactModel contact;

  const MedicalContactDialog({Key? key, required this.contact}) : super(key: key);

  @override
  State<MedicalContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<MedicalContactDialog> {
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: kBlueGrey, // Dark background
        content: Container(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.contact.name.name!,
                  style: MyFonts.w700.setColor(kWhite).size(20).copyWith(fontWeight: FontWeight.bold),

                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10,),
                _buildInfoRow(Icons.work, widget.contact.designation!),
                _buildInfoRow(Icons.school, widget.contact.degree!),
                _buildInfoRow(Icons.phone, "0361258${widget.contact.phone}"),
                _buildInfoRow(Icons.email, widget.contact.email!),
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
                      await launchPhoneURL(widget.contact.phone!);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }

                  }, icon: const Icon(Icons.call, color: Colors.green),),
                  IconButton(onPressed: () async {
                    try {
                      await launchEmailURL(widget.contact.email!);
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
  }
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
            style: MyFonts.w700.setColor(kWhite3).size(15),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
