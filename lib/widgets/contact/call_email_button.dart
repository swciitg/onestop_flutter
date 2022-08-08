import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

enum ContactType { call, email }

class ContactButton extends StatelessWidget {
  ContactType type;
  String data;
  ContactButton({Key? key, required this.type, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              (type == ContactType.email)
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
                (type == ContactType.email) ? 'Email' : 'Call',
                style: MyFonts.w500.setColor(kWhite).size(14),
              ),
            ],
          ),
        ),
      ),
      onPressed: () async {
        try {
          if (type == ContactType.email) {
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
}
