import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_dev/widgets/contact/contact_display.dart';
import 'package:provider/provider.dart';

class ContactDetailsPage extends StatefulWidget {
  final String title;
  final ContactModel? contact;
  const ContactDetailsPage({Key? key, this.contact, required this.title})
      : super(key: key);
  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var contactStore = context.read<ContactStore>();
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
                    widget.contact!.sectionName,
                    style: MyFonts.w600.size(16).setColor(kWhite),
                  ),
                ),
                // const Expanded(child: SizedBox()),
                // Padding(
                //   padding: const EdgeInsets.only(right: 8.0),
                //   child: Text(
                //     widget.contact!.group,
                //     style: MyFonts.w400.size(14).setColor(kGrey2),
                //   ),
                // )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2),
                  child: Text(
                    '${widget.contact!.contacts.length} contacts',
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
                ContactTextHeader(
                    text: 'Name',
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    align: AlignmentDirectional.topStart),
                ContactTextHeader(
                    text: 'Email id',
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    align: AlignmentDirectional.center),
                ContactTextHeader(
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
                  children: widget.contact!.contacts.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => Provider<ContactStore>.value(
                                    value: contactStore,
                                    child: ContactDialog(details: item),
                                  ),
                              barrierDismissible: true);
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
                                text: item.contact.toString(),
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
