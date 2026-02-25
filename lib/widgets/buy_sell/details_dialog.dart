import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/claim_call_button.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

void detailsDialogBox(BuildContext context, dynamic model, [parentContext]) {
  final screenWidth = MediaQuery.of(context).size.width;
  parentContext ??= context;

  final bool isBnS = model is BuyModel || model is SellModel;
  final bool isOwner = isBnS && model.email == LoginStore.userData['outlookEmail'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColor.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(OSpacing.m, OSpacing.l, OSpacing.m, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title + Close
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: OSpacing.xs),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(OSpacing.xs),
                          decoration: BoxDecoration(color: OColor.gray100, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: OColor.gray800, size: 24),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: OSpacing.l),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 320, maxWidth: screenWidth - 32),
                      child: Image.network(
                        model.imageURL,
                        fit: BoxFit.cover,
                        width: screenWidth - 32,
                        cacheWidth: (screenWidth - 32).round(),
                        frameBuilder: restaurantTileFrameBuilder,
                        errorBuilder:
                            (_, _, _) => Container(
                              height: 200,
                              color: OColor.gray200,
                              child: Icon(Icons.image_outlined, color: OColor.gray400, size: 48),
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: OSpacing.l),

                  // Price or Location
                  if (isBnS) ...[
                    Text(
                      'Asking Price',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.xxs),
                    Text(
                      '\u{20B9} ${model.price}',
                      style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                    ),
                  ] else ...[
                    Text(
                      '${(model is FoundModel) ? "Found" : "Lost"} at',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.xxs),
                    Text(
                      model.location,
                      style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                    ),
                  ],

                  const SizedBox(height: OSpacing.l),

                  // Description
                  Text('Description', style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
                  const SizedBox(height: OSpacing.xxs),
                  Text(
                    model.description,
                    style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
                  ),

                  const SizedBox(height: OSpacing.l),

                  // Brand New banner (for BnS items that are new)
                  if (isBnS && model.isNew == true) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(OSpacing.m),
                      decoration: BoxDecoration(
                        color: OColor.blue500,
                        borderRadius: BorderRadius.circular(OCornerRadius.m),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome, color: OColor.white, size: 24),
                              const SizedBox(width: OSpacing.xs),
                              Text(
                                'Brand New Item',
                                style: OTextStyle.labelSmall.copyWith(color: OColor.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: OSpacing.xs),
                          Text(
                            'This Item is brand new and has never been used.',
                            style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: OSpacing.l),
                  ],

                  // Found model claim details
                  if (model is FoundModel) ...[
                    if (model.claimed == true)
                      Text(
                        'Claimer: ${model.claimerEmail}',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                      ),
                    Text(
                      'Submitted at: ${model.submittedat}',
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.l),
                  ],

                  // Posted by
                  Text('Posted by', style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
                  const SizedBox(height: OSpacing.xs),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: OColor.gray200,
                        child: Icon(Icons.person, color: OColor.gray400, size: 28),
                      ),
                      const SizedBox(width: OSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.username ?? '',
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                            ),
                            Text(
                              model.email,
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: OSpacing.l),

                  // Action buttons
                  if (isBnS && !isOwner)
                    _BnsActionButtons(model: model)
                  else if (isBnS && isOwner)
                    _DeleteButton(model: model, parentContext: parentContext)
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ClaimCallButton(model: model, parentContext: parentContext),
                        ),
                      ],
                    ),

                  const SizedBox(height: OSpacing.m),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

/// Three action buttons: Call, Text, Mail — matching Figma design
class _BnsActionButtons extends StatelessWidget {
  const _BnsActionButtons({required this.model});
  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: FluentIcons.call_24_regular,
            label: 'Call',
            onTap: () async {
              try {
                await launchPhoneURL(model.phonenumber);
              } catch (_) {}
            },
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        Expanded(
          child: _ActionButton(
            icon: FluentIcons.chat_24_regular,
            label: 'Text',
            onTap: () async {
              try {
                final uri = Uri.parse('sms:+91${model.phonenumber}');
                await launchUrl(uri);
              } catch (_) {}
            },
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        Expanded(
          child: _ActionButton(
            icon: FluentIcons.mail_24_regular,
            label: 'Mail',
            onTap: () async {
              try {
                await launchEmailURL(model.email);
              } catch (_) {}
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: OColor.gray300),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: OColor.green600),
            const SizedBox(width: OSpacing.xxs),
            Text(label, style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
          ],
        ),
      ),
    );
  }
}

/// Delete button shown to the item owner
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.model, required this.parentContext});
  final dynamic model;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                backgroundColor: OColor.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.m)),
                title: Text(
                  'Delete this ad?',
                  style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                ),
                content: Text(
                  'This action cannot be undone.',
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Cancel',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await BnsRepository().deleteBnsMyAd(model.id, model.email);
                      } catch (_) {}
                      if (!ctx.mounted) return;
                      Navigator.of(ctx).pop(); // close dialog
                      if (!context.mounted) return;
                      Navigator.of(context).pop(); // close bottom sheet
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ad deleted',
                            style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Delete',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.red500),
                    ),
                  ),
                ],
              ),
        );
      },
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: OColor.red500),
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.delete_24_regular, size: 18, color: OColor.red500),
            const SizedBox(width: OSpacing.xs),
            Text('Delete Ad', style: OTextStyle.labelSmall.copyWith(color: OColor.red500)),
          ],
        ),
      ),
    );
  }
}
