import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Shows a bottom sheet listing all contacts in a category.
void showContactCategorySheet(
  BuildContext context, {
  required ContactModel contactModel,
  required ContactStore contactStore,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Provider<ContactStore>.value(
        value: contactStore,
        child: _CategorySheetContent(contactModel: contactModel),
      );
    },
  );
}

class _CategorySheetContent extends StatelessWidget {
  final ContactModel contactModel;

  const _CategorySheetContent({required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: OSpacing.xs),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: OColor.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        contactModel.sectionName,
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: OColor.gray100, shape: BoxShape.circle),
                        child: Icon(
                          FluentIcons.dismiss_24_regular,
                          size: 18,
                          color: OColor.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: OColor.gray200),

              // Contacts list
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                  itemCount: contactModel.contacts.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: OColor.gray100),
                  itemBuilder: (context, index) {
                    final contact = contactModel.contacts[index];
                    return InkWell(
                      onTap: () {
                        showContactProfileSheet(context, details: contact);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.m,
                          vertical: OSpacing.s,
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: OColor.gray100,
                              child: Icon(
                                FluentIcons.person_24_regular,
                                color: OColor.green600,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: OSpacing.m),
                            // Name + description
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
                                      style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            // Phone icon button
                            if (contact.contact.isNotEmpty && contact.contact != '123456789')
                              GestureDetector(
                                onTap: () {
                                  showContactProfileSheet(context, details: contact);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: OColor.gray100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    FluentIcons.call_24_regular,
                                    color: OColor.green600,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
