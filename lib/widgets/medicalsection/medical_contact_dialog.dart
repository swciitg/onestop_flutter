

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MedicalContactDialog extends StatefulWidget {
  final MedicalcontactModel details;

  const MedicalContactDialog({Key? key, required this.details}) : super(key: key);

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
      backgroundColor: kBlueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              "${widget.details.name} ${widget.details.degree}",
              style: MyFonts.w600.size(24).setColor(kWhite),
            ),
          ),
        ],
      ),
      content: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              widget.details.designation,
              style: MyFonts.w600.size(24).setColor(kWhite),
            ),
          ),
          ContactButton(type: ContactType.call, data: widget.details.phone),
          ContactButton(type: ContactType.email, data: widget.details.email),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Done', style: MyFonts.w500.size(14).setColor(kWhite)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
