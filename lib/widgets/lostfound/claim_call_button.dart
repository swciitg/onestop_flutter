import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

class ClaimCallButton extends StatefulWidget {
  final dynamic model;
  final BuildContext parentContext;

  const ClaimCallButton({super.key, required this.model, required this.parentContext});

  @override
  State<ClaimCallButton> createState() => _ClaimCallButtonState();
}

class _ClaimCallButtonState extends State<ClaimCallButton> {
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.model is FoundModel) {
      return _buildFoundActions(context);
    } else {
      return _buildLostActions(context);
    }
  }

  /// Found items: Claim button + Call/Text/Mail
  Widget _buildFoundActions(BuildContext context) {
    final foundModel = widget.model as FoundModel;
    final bool alreadyClaimed = foundModel.claimed == true;
    final bool claimedByMe = foundModel.claimerEmail == LoginStore.userData["outlookEmail"];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Claim button
        if (!alreadyClaimed)
          GestureDetector(
            onTap: () => _showClaimDialog(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
              decoration: BoxDecoration(
                color: OColor.green600,
                borderRadius: BorderRadius.circular(OCornerRadius.m),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.hand_left_24_regular, size: 20, color: OColor.white),
                  const SizedBox(width: OSpacing.xs),
                  Text('Claim Item', style: OTextStyle.labelMedium.copyWith(color: OColor.white)),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
            decoration: BoxDecoration(
              color: OColor.gray200,
              borderRadius: BorderRadius.circular(OCornerRadius.m),
            ),
            alignment: Alignment.center,
            child: Text(
              claimedByMe ? 'You claimed this item' : 'Already Claimed',
              style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
            ),
          ),
        const SizedBox(height: OSpacing.s),
        // Call / Text / Mail
        _buildActionButtonsRow(context),
      ],
    );
  }

  /// Lost items: Call/Text/Mail
  Widget _buildLostActions(BuildContext context) {
    return _buildActionButtonsRow(context);
  }

  Widget _buildActionButtonsRow(BuildContext context) {
    return Row(
      children: [
        // Call
        if (_hasPhone) ...[
          Expanded(
            child: GestureDetector(
              onTap: () async {
                try {
                  await launchPhoneURL(widget.model.phonenumber);
                } catch (e) {
                  if (kDebugMode) print(e);
                }
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                  border: Border.all(color: OColor.gray300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.call_24_regular, size: 20, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text('Call', style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          // Text
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse('sms:+91${widget.model.phonenumber}');
                await launchUrl(uri);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                  border: Border.all(color: OColor.gray300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.chat_24_regular, size: 20, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text('Text', style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: OSpacing.xs),
        ],
        // Mail
        Expanded(
          child: GestureDetector(
            onTap: () => launchEmailURL(widget.model.email),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(OCornerRadius.m),
                border: Border.all(color: OColor.gray300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.mail_24_regular, size: 20, color: OColor.green600),
                  const SizedBox(width: OSpacing.xxs),
                  Text('Mail', style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool get _hasPhone {
    try {
      final phone = widget.model.phonenumber;
      return phone != null && phone.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showClaimDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext claimDialogContext) {
        return AlertDialog(
          backgroundColor: OColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.m)),
          title: Text(
            'Are you sure you want to claim this item?',
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(claimDialogContext),
              child: Text('No', style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
            ),
            TextButton(
              onPressed: () async {
                if (buttonPressed) return;
                buttonPressed = true;
                var name = LoginStore.userData['name'];
                var email = LoginStore.userData['outlookEmail'];
                var body = await LnfRepository().claimFoundItem(
                  name: name!,
                  email: email!,
                  id: widget.model.id,
                );

                buttonPressed = false;
                if (!mounted) return;
                if (body["saved"] == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        body["message"],
                        style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                      ),
                    ),
                  );
                  Navigator.popUntil(context, ModalRoute.withName(LostFoundHome.id));
                } else {
                  widget.model.claimed = true;
                  widget.model.claimerEmail = LoginStore.userData["outlookEmail"]!;
                  Navigator.popUntil(context, ModalRoute.withName(LostFoundHome.id));
                  ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Claimed Item Successfully',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                      ),
                    ),
                  );
                }
              },
              child: Text('Yes', style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
            ),
          ],
        );
      },
    );
  }
}
