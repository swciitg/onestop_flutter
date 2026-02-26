import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/widgets/contact/call_email_button.dart';
import 'package:onestop_ui/index.dart' hide ContactActionType;

/// Shows a bottom sheet with a medical contact's profile details.
void showMedicalContactSheet(
  BuildContext context, {
  required MedicalcontactModel contact,
  required bool isMisc,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _MedicalContactSheetContent(contact: contact, isMisc: isMisc);
    },
  );
}

class _MedicalContactSheetContent extends StatelessWidget {
  final MedicalcontactModel contact;
  final bool isMisc;

  const _MedicalContactSheetContent({required this.contact, required this.isMisc});

  @override
  Widget build(BuildContext context) {
    final name = isMisc ? contact.miscellaneousContact! : contact.name.name!;
    final phone = '361258${contact.phone}';
    final email = contact.email ?? '';

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
          // Header: icon + "Medical Contact" + close button
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: OColor.green100, shape: BoxShape.circle),
                child: Icon(FluentIcons.stethoscope_24_regular, size: 20, color: OColor.green600),
              ),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: Text(
                  'Medical Contact',
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

          // Profile: avatar + name + designation/degree
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
                      name,
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isMisc &&
                        contact.name.designation != null &&
                        contact.name.designation!.isNotEmpty)
                      Text(
                        contact.name.designation!,
                        style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.l),

          // Info rows
          if (!isMisc && contact.name.degree != null && contact.name.degree!.isNotEmpty) ...[
            Row(
              children: [
                Icon(FluentIcons.hat_graduation_24_regular, size: 16, color: OColor.gray500),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: Text(
                    contact.name.degree!,
                    style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: OSpacing.xs),
          ],
          if (phone.isNotEmpty && contact.phone != null && contact.phone!.isNotEmpty) ...[
            Row(
              children: [
                Icon(FluentIcons.call_24_regular, size: 16, color: OColor.gray500),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: Text(phone, style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
                ),
              ],
            ),
            const SizedBox(height: OSpacing.xs),
          ],
          if (email.isNotEmpty) ...[
            Row(
              children: [
                Icon(FluentIcons.mail_24_regular, size: 16, color: OColor.gray500),
                const SizedBox(width: OSpacing.xs),
                Expanded(
                  child: Text(email, style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
                ),
              ],
            ),
          ],
          const SizedBox(height: OSpacing.l),

          // Action buttons: Call / Text / Mail
          Row(
            children: [
              if (contact.phone != null && contact.phone!.isNotEmpty) ...[
                Expanded(child: ContactActionButton(type: ContactActionType.call, data: phone)),
                const SizedBox(width: OSpacing.xs),
                Expanded(child: ContactActionButton(type: ContactActionType.text, data: phone)),
              ],
              if (email.isNotEmpty) ...[
                if (contact.phone != null && contact.phone!.isNotEmpty)
                  const SizedBox(width: OSpacing.xs),
                Expanded(child: ContactActionButton(type: ContactActionType.mail, data: email)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
