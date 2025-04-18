import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_dev/widgets/contact/star_button.dart';
import 'package:onestop_kit/onestop_kit.dart';

class ContactDialog extends StatefulWidget {
  final ContactDetailsModel details;

  const ContactDialog({super.key, required this.details});

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
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
              widget.details.name,
              style: MyFonts.w600.size(24).setColor(kWhite),
            ),
          ),
          Expanded(
            flex: 2,
            child: StarButton(
              contact: widget.details,
            ),
          ),
        ],
      ),
      content: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ContactButton(type: ContactType.call, data: widget.details.contact),
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
