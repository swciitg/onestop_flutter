import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/widgets/food/restaurant/call_map_button.dart';

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
                child: IconButton(
              onPressed: () {
                setState(() {
                  isStarred = !isStarred;
                });
              },
              icon: isStarred
                  ? Icon(Icons.star, color: Colors.amber,)
                  : Icon(Icons.star_outline, color: kGrey,),
            )),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          contact_button(1, widget.details.contact),
          contact_button(0, widget.details.email),
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

contact_button(int x, String data) {
  return TextButton(
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      child: Container(
        height: 32,
        width: 100,
        color: kGrey9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (x == 0)
                ? Icon(
                    Icons.email,
                    color: kWhite,
                  )
                : Icon(
                    Icons.call,
                    color: kWhite,
                  ),
            Container(
              width: 5,
            ),
            Text(
              (x == 0) ? 'Email' : 'Call',
              style: MyFonts.w500.setColor(kWhite).size(14),
            ),
          ],
        ),
      ),
    ),
    onPressed: () async {
      try {
        if (x == 0) {
          await launchEmailURL(data);
        } else {
          await launchPhoneURL(data);
        }
      } catch (_e) {
        print(_e);
      }
    },
  );
}
