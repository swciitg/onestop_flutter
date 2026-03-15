import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_dev/widgets/contact/star_button.dart';
import 'package:onestop_ui/index.dart' hide ContactActionType;
import 'package:provider/provider.dart';

/// Shows a bottom sheet with a single contact's profile details.
void showContactProfileSheet(BuildContext context, {required ContactDetailsModel details}) {
  final contactStore = context.read<ContactStore>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Provider<ContactStore>.value(
        value: contactStore,
        child: _ProfileSheetContent(details: details),
      );
    },
  );
}

class _ProfileSheetContent extends StatelessWidget {
  final ContactDetailsModel details;

  const _ProfileSheetContent({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        border: Border.all(color: OColor.gray200),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: icon + "Contact" + close button
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: OColor.green100, shape: BoxShape.circle),
                child: Icon(FluentIcons.person_24_regular, size: 20, color: OColor.green600),
              ),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: Text(
                  'Contact',
                  style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: OColor.gray100, shape: BoxShape.circle),
                  child: Icon(FluentIcons.dismiss_24_regular, size: 18, color: OColor.gray600),
                ),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.l),

          // Profile: avatar + name + designation
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: OColor.gray100,
                child: Icon(FluentIcons.person_24_regular, color: OColor.green600, size: 24),
              ),
              const SizedBox(width: OSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.name,
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StarButton(contact: details),
            ],
          ),
          const SizedBox(height: OSpacing.l),

          // Contact info rows
          if (details.contact.isNotEmpty && details.contact != '123456789') ...[
            Row(
              children: [
                Icon(FluentIcons.call_24_regular, size: 16, color: OColor.gray500),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: Text(
                    details.contact,
                    style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: OSpacing.xs),
          ],
          if (details.email.isNotEmpty && details.email != 'Unknown') ...[
            Row(
              children: [
                Icon(FluentIcons.mail_24_regular, size: 16, color: OColor.gray500),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: Text(
                    details.email,
                    style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: OSpacing.l),

          // Action buttons: Call / Text / Mail
          Row(
            children: [
              if (details.contact.isNotEmpty && details.contact != '123456789') ...[
                Expanded(
                  child: ContactActionButton(type: ContactActionType.call, data: details.contact),
                ),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: ContactActionButton(type: ContactActionType.text, data: details.contact),
                ),
              ],
              if (details.email.isNotEmpty && details.email != 'Unknown') ...[
                if (details.contact.isNotEmpty && details.contact != '123456789')
                  const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: ContactActionButton(type: ContactActionType.mail, data: details.email),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
