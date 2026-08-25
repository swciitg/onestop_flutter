import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/widgets/poc_modal.dart';
import 'package:onestop_ui/index.dart';

/// Shows the event detail popup as a modal bottom sheet.
///
/// Follows the same pattern as [showContactProfileSheet] in contact_dialog.dart.
void showEventPopup(BuildContext context, {required EventModel event}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return _EventPopupContent(
            event: event,
            scrollController: scrollController,
          );
        },
      );
    },
  );
}

class _EventPopupContent extends StatelessWidget {
  final EventModel event;
  final ScrollController scrollController;

  const _EventPopupContent({
    required this.event,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: OSpacing.s),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: OColor.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m)
                  .copyWith(top: OSpacing.m, bottom: OSpacing.l),
              children: [
                // Header: title + close button
                _buildHeader(context),
                const SizedBox(height: OSpacing.xs),

                // Image preview
                _buildImagePreview(),
                const SizedBox(height: OSpacing.m),

                // Action buttons: Register + I'm Interested
                _buildActionButtons(),
                const SizedBox(height: OSpacing.l),

                // Tags
                _buildTags(),
                const SizedBox(height: OSpacing.l),

                // Location and time
                _buildLocationAndTime(),
                const SizedBox(height: OSpacing.l),

                // Special Guests
                _buildSpecialGuests(),
                const SizedBox(height: OSpacing.l),

                // Description
                _buildSection(
                  label: 'Description',
                  content: event.description,
                ),
                const SizedBox(height: OSpacing.s),

                // Divider
                Divider(height: 1, color: OColor.gray200),
                const SizedBox(height: OSpacing.l),

                // Who should attend
                _buildSection(
                  label: 'Who should attend?',
                  content: event.description,
                ),
                const SizedBox(height: OSpacing.s),

                // Divider
                Divider(height: 1, color: OColor.gray200),
                const SizedBox(height: OSpacing.l),

                // Posted By
                _buildPostedBy(),
                const SizedBox(height: OSpacing.l),

                // POCs
                _buildPOCs(context),
                const SizedBox(height: OSpacing.l),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header row: event title + close button
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: OText(
            text: event.title,
            style: OTextStyle.labelLarge.copyWith(
              color: OColor.gray800,
              fontSize: 18,
              height: 24 / 18,
            ),
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration:  BoxDecoration(
              color: OColor.gray100,
              shape: BoxShape.circle,
            ),
            child:  Icon(
              FluentIcons.dismiss_24_regular,
              size: 24,
              color: OColor.gray800,
            ),
          ),
        ),
      ],
    );
  }

  /// Image preview with rounded corners
  Widget _buildImagePreview() {
    final imageUrl = event.imageUrl ?? event.compressedImageUrl;
    return AspectRatio(
      aspectRatio: 358 / 201,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: OColor.gray200,
      child:  Center(
        child: Icon(
          FluentIcons.image_24_regular,
          size: 48,
          color: OColor.gray400,
        ),
      ),
    );
  }

  /// Two action buttons: "Register" (primary) and "I'm Interested" (secondary)
  Widget _buildActionButtons() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Register button (primary, green filled)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: OColor.green600,
                borderRadius: BorderRadius.circular(OCornerRadius.m),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    FluentIcons.edit_16_regular,
                    size: 16,
                    color: OColor.white,
                  ),
                  const SizedBox(width: OSpacing.xxs),
                  OText(
                    text: 'Register',
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: OSpacing.s),
          // I'm Interested button (secondary, outlined)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(OCornerRadius.m),
                border: Border.all(color: OColor.gray300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    FluentIcons.heart_16_regular,
                    size: 16,
                    color: OColor.green600,
                  ),
                  const SizedBox(width: OSpacing.xxs),
                  OText(
                    text: "I'm Interested",
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.green600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Category tags (pills)
  Widget _buildTags() {
    if (event.categories.isEmpty) return const SizedBox.shrink();

    final tagColors = [OColor.blue600, OColor.green600];

    return Wrap(
      spacing: OSpacing.m,
      runSpacing: OSpacing.xs,
      children: event.categories.take(2).toList().asMap().entries.map((entry) {
        final color = tagColors[entry.key % tagColors.length];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: OColor.gray100,
            borderRadius: BorderRadius.circular(OCornerRadius.l),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FluentIcons.tag_16_regular,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              OText(
                text: entry.value.toUpperCase(),
                style: OTextStyle.labelSmall.copyWith(color: color),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Location and time info rows
  Widget _buildLocationAndTime() {
    final timeFormat = DateFormat('h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Row(
          children: [
             Icon(
              FluentIcons.location_16_regular,
              size: 16,
              color: OColor.gray600,
            ),
            const SizedBox(width: OSpacing.xxs),
            Expanded(
              child: OText(
                text: event.venue,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: OSpacing.xxs),
        // Time
        Row(
          children: [
             Icon(
              FluentIcons.clock_16_regular,
              size: 16,
              color: OColor.gray600,
            ),
            const SizedBox(width: OSpacing.xxs),
            Expanded(
              child: OText(
                text:
                    '${timeFormat.format(event.startDateTime)} - ${timeFormat.format(event.endDateTime)}',
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Special Guests section with profile avatars
  Widget _buildSpecialGuests() {
    // Placeholder guest data (would come from API in real implementation)
    final guests = [
      {'name': 'Guest 1', 'role': 'Organizer'},
      {'name': 'Guest 2', 'role': 'Co-Organizer'},
      {'name': 'Guest 3', 'role': 'Speaker'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'Special Guest',
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: guests.map((guest) {
              return Padding(
                padding: const EdgeInsets.only(right: OSpacing.l),
                child: _buildProfileChip(
                  name: guest['name']!,
                  subtitle: guest['role']!,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Reusable text section with a label and body content
  Widget _buildSection({
    required String label,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: label,
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.xxs),
        OText(
          text: content,
          style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
        ),
      ],
    );
  }

  /// Posted By section with organizer avatar
  Widget _buildPostedBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'Posted By',
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.s),
        Row(
          children: [
            // Organizer avatar
            Container(
              width: 48,
              height: 48,
              decoration:  BoxDecoration(
                color: OColor.gray200,
                shape: BoxShape.circle,
              ),
              child:  Icon(
                FluentIcons.people_24_regular,
                size: 24,
                color: OColor.gray600,
              ),
            ),
            const SizedBox(width: OSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OText(
                    text: event.clubOrg,
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OText(
                    text: event.board,
                    style: OTextStyle.bodyXSmall.copyWith(
                      color: OColor.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// POCs section with contact avatars
  Widget _buildPOCs(BuildContext context) {
    // Placeholder POC data (would come from API in real implementation)
    final pocs = [
      {'name': 'POC 1', 'role': 'Events Head'},
      {'name': 'POC 2', 'role': 'Events Head'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'POCs',
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.s),
        Wrap(
          spacing: OSpacing.l,
          runSpacing: OSpacing.s,
          children: pocs.map((poc) {
            return _buildProfileChip(
              context: context,
              name: poc['name']!,
              subtitle: poc['role']!,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// A single profile chip: avatar circle + name + subtitle, stacked vertically
  Widget _buildProfileChip({
    BuildContext? context,
    required String name,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        if (context != null) {
          showPOCModal(context, name: name, subtitle: subtitle);
        }
      },
      child: SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:  BoxDecoration(
              color: OColor.blue100,
              shape: BoxShape.circle,
            ),
            child:  Icon(
              FluentIcons.person_24_regular,
              size: 32,
              color: OColor.blue500,
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          OText(
            text: name,
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          OText(
            text: subtitle,
            style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ));
  }
}
