import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class StarContactNameTile extends StatelessWidget {
  final ContactDetailsModel contact;

  const StarContactNameTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showContactProfileSheet(context, details: contact, contactStore: context.read<ContactStore>());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: OColor.gray100,
              child: Icon(FluentIcons.person_24_regular, color: OColor.green600, size: 20),
            ),
            const SizedBox(width: OSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (contact.email.isNotEmpty && contact.email != 'Unknown')
                    Text(
                      contact.email,
                      style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (contact.contact.isNotEmpty && contact.contact != '123456789')
              Icon(FluentIcons.call_24_regular, color: OColor.green600, size: 20),
          ],
        ),
      ),
    );
  }
}
