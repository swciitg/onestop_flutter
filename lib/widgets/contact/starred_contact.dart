import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:provider/provider.dart';

class StarContactNameTile extends StatelessWidget {
  ContactDetailsModel contact;
  StarContactNameTile({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int size = contact.name.length;
    var contactStore = Provider.of<ContactStore>(context, listen: false);

    return TextButton(
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        child: Container(
          height: 32,
          width: 10 * size + 25,
          color: kGrey9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                contact.name,
                style: MyFonts.w400.setColor(kWhite),
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
