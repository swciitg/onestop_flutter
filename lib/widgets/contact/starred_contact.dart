import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class StarContactNameTile extends StatelessWidget {
  final ContactDetailsModel contact;

  const StarContactNameTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    var contactStore = Provider.of<ContactStore>(context, listen: false);
    return TextButton(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        child: Container(
          height: 32,
          color: kGrey9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.5, right: 12.5),
                child: Text(
                  contact.name,
                  style: MyFonts.w400.setColor(kWhite),
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => Provider<ContactStore>.value(
                  value: contactStore,
                  child: ContactDialog(details: contact),
                ),
            barrierDismissible: true);
      },
    );
  }
}
