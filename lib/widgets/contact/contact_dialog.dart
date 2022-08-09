import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_dev/widgets/contact/star_button.dart';
import 'package:provider/provider.dart';

class ContactDialog extends StatefulWidget {
  final ContactDetailsModel details;
  const ContactDialog({Key? key, required this.details}) : super(key: key);

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  bool isStarred = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Before alert dialog ${context.read<ContactStore>()}");
    return AlertDialog(
      backgroundColor: kBlueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: Text(
                widget.details.name,
                style: MyFonts.w600.size(24).setColor(kWhite),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: StarButton(
                contact: widget.details,
              ),
            ),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
