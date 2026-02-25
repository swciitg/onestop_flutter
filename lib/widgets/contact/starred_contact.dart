import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_ui/index.dart';

class StarContactNameTile extends StatelessWidget {
  final ContactDetailsModel contact;

  const StarContactNameTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showContactProfileSheet(context, details: contact);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: OSpacing.m),
        child: SizedBox(
          width: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: OColor.gray100,
                child: Icon(FluentIcons.person_24_regular, color: OColor.green600, size: 22),
              ),
              const SizedBox(height: OSpacing.xxs),
              Text(
                contact.name.split(' ').first,
                style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
