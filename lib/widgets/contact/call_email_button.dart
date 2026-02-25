import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum ContactActionType { call, text, mail }

class ContactActionButton extends StatelessWidget {
  final ContactActionType type;
  final String data;

  const ContactActionButton({super.key, required this.type, required this.data});

  IconData get _icon {
    switch (type) {
      case ContactActionType.call:
        return FluentIcons.call_24_regular;
      case ContactActionType.text:
        return FluentIcons.chat_24_regular;
      case ContactActionType.mail:
        return FluentIcons.mail_24_regular;
    }
  }

  String get _label {
    switch (type) {
      case ContactActionType.call:
        return 'Call';
      case ContactActionType.text:
        return 'Text';
      case ContactActionType.mail:
        return 'Mail';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        try {
          switch (type) {
            case ContactActionType.call:
              await launchPhoneURL(data);
              break;
            case ContactActionType.text:
              final url = 'sms:+91$data';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
              break;
            case ContactActionType.mail:
              await launchEmailURL(data);
              break;
          }
        } catch (e) {
          if (kDebugMode) print(e);
        }
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: OColor.gray300),
          borderRadius: BorderRadius.circular(OCornerRadius.l),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 16, color: OColor.green600),
            const SizedBox(width: OSpacing.xs),
            Text(_label, style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
          ],
        ),
      ),
    );
  }
}
