import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';
import 'package:onestop_ui/index.dart';
import 'package:url_launcher/url_launcher.dart';

class LostFoundTile extends StatelessWidget {
  final dynamic currentModel;
  final BuildContext? parentContext;

  const LostFoundTile({super.key, required this.currentModel, this.parentContext});

  @override
  Widget build(BuildContext context) {
    final isFound = currentModel is FoundModel;
    final String timeString = DateFormat('h:mm a').format(currentModel.date);

    return GestureDetector(
      onTap: () {
        if (parentContext != null) {
          detailsDialogBox(context, currentModel, parentContext!);
        } else {
          detailsDialogBox(context, currentModel);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: image + info
            Padding(
              padding: const EdgeInsets.fromLTRB(OSpacing.s, OSpacing.s, OSpacing.s, OSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(OCornerRadius.s),
                    child: SizedBox(
                      width: 112,
                      height: 112,
                      child: Image.network(
                        currentModel.compressedImageURL,
                        fit: BoxFit.cover,
                        cacheWidth: 224,
                        frameBuilder: restaurantTileFrameBuilder,
                        errorBuilder:
                            (_, _, _) => Container(
                              color: OColor.gray200,
                              child: Icon(Icons.image_outlined, color: OColor.gray400, size: 32),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: OSpacing.xs),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + chevron
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentModel.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.gray800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              FluentIcons.chevron_right_24_regular,
                              size: 24,
                              color: OColor.gray800,
                            ),
                          ],
                        ),
                        const SizedBox(height: OSpacing.xxs),
                        // Time
                        Row(
                          children: [
                            Icon(FluentIcons.clock_24_regular, size: 16, color: OColor.gray600),
                            const SizedBox(width: 4),
                            Text(
                              timeString,
                              style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                            ),
                          ],
                        ),
                        // Location
                        Row(
                          children: [
                            Icon(FluentIcons.location_24_regular, size: 16, color: OColor.gray600),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                currentModel.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                              ),
                            ),
                          ],
                        ),
                        // Submitted at (for Found items)
                        if (isFound && (currentModel as FoundModel).submittedat.isNotEmpty) ...[
                          const SizedBox(height: OSpacing.xs),
                          Text(
                            'SUBMITTED AT',
                            style: OTextStyle.labelSmall.copyWith(
                              color: OColor.gray600,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            (currentModel as FoundModel).submittedat,
                            style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.s),
              child: Divider(height: 1, color: OColor.gray200),
            ),
            // Footer: profile + action icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.s, vertical: OSpacing.xs),
              child: Row(
                children: [
                  // Avatar placeholder
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: OColor.gray200,
                    child: Icon(FluentIcons.person_24_regular, size: 14, color: OColor.gray600),
                  ),
                  const SizedBox(width: OSpacing.xs),
                  // Name — use email prefix as display name
                  Expanded(
                    child: Text(
                      currentModel.email.split('@').first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                    ),
                  ),
                  // Phone icon (only for Lost items with phone)
                  if (!isFound) ...[
                    GestureDetector(
                      onTap: () => launchPhoneURL(currentModel.phonenumber),
                      child: Padding(
                        padding: const EdgeInsets.all(OSpacing.xs),
                        child: Icon(FluentIcons.call_24_regular, size: 24, color: OColor.green600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse('sms:+91${currentModel.phonenumber}');
                        await launchUrl(uri);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(OSpacing.xs),
                        child: Icon(FluentIcons.chat_24_regular, size: 24, color: OColor.green600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
