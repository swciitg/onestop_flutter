import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/globals/database_strings.dart';
import 'package:onestop_dev/services/local_storage.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_ui/index.dart' hide ContactActionType;
import 'package:provider/provider.dart';

/// Shows a bottom sheet with a single contact's profile details.
void showContactProfileSheet(BuildContext context, {required ContactDetailsModel details, required ContactStore contactStore}) {
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

          // Profile: avatar + name
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
          const SizedBox(height: OSpacing.xs),

          // Add to Favourite button
          _FavouriteButton(contact: details),
        ],
      ),
    );
  }
}

class _FavouriteButton extends StatefulWidget {
  final ContactDetailsModel contact;
  const _FavouriteButton({required this.contact});

  @override
  State<_FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<_FavouriteButton> {
  Future<bool> _isStarred() async {
    var starred = await LocalStorage.instance.getListRecord(DatabaseRecords.starredContacts);
    if (starred == null) return false;
    var starredContacts =
        starred.map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>)).toList();
    return starredContacts.any((e) =>
        e.name == widget.contact.name &&
        e.email == widget.contact.email &&
        e.contact == widget.contact.contact);
  }

  Future<void> _toggle(bool isAlreadyStarred) async {
    var starred = await LocalStorage.instance.getListRecord(DatabaseRecords.starredContacts);
    if (isAlreadyStarred) {
      if (starred == null) return;
      var starredContacts =
          starred.map((e) => ContactDetailsModel.fromJson(e as Map<String, dynamic>)).toList();
      starredContacts.removeWhere((e) =>
          e.name == widget.contact.name &&
          e.email == widget.contact.email &&
          e.contact == widget.contact.contact);
      if (!mounted) return;
      context.read<ContactStore>().setStarredContacts(starredContacts);
      if (starredContacts.isEmpty) {
        await LocalStorage.instance.deleteRecord(DatabaseRecords.starredContacts);
      } else {
        await LocalStorage.instance.storeListRecord(
          starredContacts.map((e) => e.toJson()).toList(),
          DatabaseRecords.starredContacts,
        );
      }
    } else {
      List<Map<String, dynamic>> starList = [];
      if (starred != null) {
        starList = starred.map((e) => e as Map<String, dynamic>).toList();
      }
      starList.add(widget.contact.toJson());
      await LocalStorage.instance.storeListRecord(starList, DatabaseRecords.starredContacts);
      if (!mounted) return;
      context.read<ContactStore>().setStarredContacts(
        starList.map((e) => ContactDetailsModel.fromJson(e)).toList(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isStarred(),
      builder: (context, snapshot) {
        final isStarred = snapshot.data ?? false;
        return GestureDetector(
          onTap: () => _toggle(isStarred),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: OColor.gray300),
              borderRadius: BorderRadius.circular(OCornerRadius.l),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isStarred ? FluentIcons.star_12_filled : FluentIcons.star_12_regular,
                  size: 16,
                  color: isStarred ? OColor.yellow500 : OColor.green600,
                ),
                const SizedBox(width: OSpacing.xs),
                Text(
                  isStarred ? 'Remove Favourite' : 'Add to Favourite',
                  style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
