import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/widgets/components/event_network_image.dart';
import 'package:onestop_dev/pages/events/widgets/poc_modal.dart';
import 'package:onestop_dev/pages/events/providers/events_provider.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Shows the event detail popup as a modal bottom sheet.
Future<void> showEventPopup(
  BuildContext context, {
  required EventModel event,
  bool? isInitiallyInterested,
  bool? isInitiallyRegistered,
  Function(bool isInterested, bool isRegistered)? onStatusChanged,
}) async {
  await showModalBottomSheet(
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
            isInitiallyInterested: isInitiallyInterested,
            isInitiallyRegistered: isInitiallyRegistered,
            onStatusChanged: onStatusChanged,
          );
        },
      );
    },
  );
}

class _EventPopupContent extends StatefulWidget {
  final EventModel event;
  final ScrollController scrollController;
  final bool? isInitiallyInterested;
  final bool? isInitiallyRegistered;
  final Function(bool isInterested, bool isRegistered)? onStatusChanged;

  const _EventPopupContent({
    required this.event,
    required this.scrollController,
    this.isInitiallyInterested,
    this.isInitiallyRegistered,
    this.onStatusChanged,
  });

  @override
  State<_EventPopupContent> createState() => _EventPopupContentState();
}

class _EventPopupContentState extends State<_EventPopupContent> {
  late EventModel event;
  bool isInterested = false;
  bool isRegistered = false;
  bool isActionLoading = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    isInterested =
        widget.isInitiallyInterested ??
        (event.userStatus?.isInterested ?? false);
    isRegistered =
        widget.isInitiallyRegistered ??
        (event.userStatus?.isRegistered ?? false);
    _fetchFullDetails();
  }

  Future<void> _fetchFullDetails() async {
    final detailed = await context.read<EventsProvider>().fetchEventDetails(
      event.id,
    );
    if (detailed != null && mounted) {
      setState(() {
        event = detailed;
        if (widget.isInitiallyInterested == null) {
          isInterested = detailed.userStatus?.isInterested ?? isInterested;
        }
        if (widget.isInitiallyRegistered == null) {
          isRegistered = detailed.userStatus?.isRegistered ?? isRegistered;
        }
      });
    }
  }

  Future<void> _toggleLikeOrInterest() async {
    final provider = context.read<EventsProvider>();
    final newStatus = !isInterested;
    setState(() {
      isInterested = newStatus;
      isActionLoading = true;
    });
    widget.onStatusChanged?.call(isInterested, isRegistered);

    final success = await provider.setGoing(event, newStatus);

    if (!mounted) return;
    setState(() {
      isActionLoading = false;
      if (!success) isInterested = !newStatus;
    });
    widget.onStatusChanged?.call(isInterested, isRegistered);
    showSnackBar(
      !success
          ? "Couldn't update your interested events"
          : isInterested
          ? "Added to your interested events!"
          : "Removed from interested events",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: OSpacing.m,
              ).copyWith(top: OSpacing.m, bottom: OSpacing.l),
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
                if (event.guest.isNotEmpty) ...[
                  _buildSpecialGuests(),
                  const SizedBox(height: OSpacing.l),
                ],

                // Description
                if (event.description != null &&
                    event.description!.isNotEmpty) ...[
                  _buildSection(
                    label: 'Description',
                    content: event.description!,
                  ),
                  const SizedBox(height: OSpacing.s),
                  Divider(height: 1, color: OColor.gray200),
                  const SizedBox(height: OSpacing.l),
                ],

                // Who should attend
                if (event.whoShouldAttend != null &&
                    event.whoShouldAttend!.isNotEmpty) ...[
                  _buildSection(
                    label: 'Who should attend?',
                    content: event.whoShouldAttend!,
                  ),
                  const SizedBox(height: OSpacing.s),
                  Divider(height: 1, color: OColor.gray200),
                  const SizedBox(height: OSpacing.l),
                ],

                // Posted By
                _buildPostedBy(),
                const SizedBox(height: OSpacing.l),

                // POCs
                if (event.poc.isNotEmpty) ...[
                  _buildPOCs(context),
                  const SizedBox(height: OSpacing.l),
                ],
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
            maxLines: 2,
            style: OTextStyle.labelLarge.copyWith(
              color: OColor.gray800,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: OSpacing.xs),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: OColor.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(TablerIcons.x, size: 24, color: OColor.gray600),
          ),
        ),
      ],
    );
  }

  /// Image preview with progressive shimmer & caching
  Widget _buildImagePreview() {
    final imageUrl = event.imageUrl ?? event.compressedImageUrl;
    return EventNetworkImage.banner(
      imageUrl: imageUrl,
      aspectRatio: 358 / 201,
      borderRadius: BorderRadius.circular(OCornerRadius.s),
    );
  }

  /// Two action buttons: "Register" (primary) and "I'm Interested" (secondary)
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Register button
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         isRegistered = !isRegistered;
        //       });
        //       widget.onStatusChanged?.call(isInterested, isRegistered);
        //       showSnackBar(
        //         isRegistered
        //             ? "Registered for ${event.title}"
        //             : "Registration cancelled for ${event.title}",
        //       );
        //     },
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: isRegistered ? OColor.green700 : OColor.green600,
        //         borderRadius: BorderRadius.circular(OCornerRadius.m),
        //         boxShadow: const [
        //           BoxShadow(color: Color(0x0A000000), blurRadius: 20),
        //         ],
        //       ),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             FluentIcons.edit_16_regular,
        //             size: 16,
        //             color: OColor.white,
        //           ),
        //           const SizedBox(width: OSpacing.xxs),
        //           OText(
        //             text: isRegistered ? 'Registered' : 'Register',
        //             style: OTextStyle.labelMedium.copyWith(color: OColor.white),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Expanded(
          child: PrimaryButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            label: isRegistered ? 'Registered' : 'Register',
            bgColor: isRegistered ? OColor.green700 : OColor.green600,
            iconColor: OColor.white,
            leadingIcon: isRegistered ? TablerIcons.check : TablerIcons.edit,
            labelStyle: OTextStyle.labelMedium.copyWith(color: OColor.white),
            onPressed: () {
              setState(() {
                isRegistered = !isRegistered;
              });
              widget.onStatusChanged?.call(isInterested, isRegistered);
              showSnackBar(
                isRegistered
                    ? "Registered for ${event.title}"
                    : "Registration cancelled for ${event.title}",
              );
            },
          ),
        ),
        const SizedBox(width: OSpacing.s),

        // I'm Interested button
        Expanded(
          child: PrimaryButton(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            label: isInterested ? "Interested" : "I'm Interested",
            bgColor: isInterested ? OColor.green100 : Colors.transparent,
            leadingIcon:
                isInterested
                    ? TablerIcons.heart_filled
                    : TablerIcons.heart_plus,
            iconColor: OColor.green600,
            labelStyle: OTextStyle.labelMedium.copyWith(color: OColor.green600),
            onPressed: isActionLoading ? null : _toggleLikeOrInterest,
          ),
        ),
      ],
    );
  }

  /// Category tags (pills)
  Widget _buildTags() {
    if (event.categories.isEmpty) return const SizedBox.shrink();

    final tagColors = [OColor.blue600, OColor.green600];

    return Wrap(
      spacing: OSpacing.m,
      runSpacing: OSpacing.xs,
      children:
          event.categories.take(3).toList().asMap().entries.map((entry) {
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
                  Icon(TablerIcons.tags_filled, size: 16, color: color),
                  const SizedBox(width: 4),
                  OText(
                    text: entry.value.toUpperCase(),
                    style: OTextStyle.labelXSmall.copyWith(color: color),
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
    final venueText =
        (event.venue != null && event.venue!.isNotEmpty)
            ? event.venue!
            : 'Campus';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Row(
          children: [
            Icon(TablerIcons.map_pin, size: 16, color: OColor.gray600),
            const SizedBox(width: OSpacing.xxs),
            Expanded(
              child: OText(
                text: venueText,
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
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
            Icon(TablerIcons.clock, size: 16, color: OColor.gray600),
            const SizedBox(width: OSpacing.xxs),
            Expanded(
              child: OText(
                text:
                    '${timeFormat.format(event.startDateTime)} - ${timeFormat.format(event.endDateTime)}',
                style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
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
            children:
                event.guest.map((g) {
                  return Padding(
                    padding: const EdgeInsets.only(right: OSpacing.l),
                    child: _buildProfileChip(
                      name: g.name ?? 'Guest',
                      subtitle: g.position ?? 'Speaker',
                      photoUrl: g.photo,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  /// Reusable text section with a label and body content
  Widget _buildSection({required String label, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: label,
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
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
    final clubTitle = event.clubOrg.isNotEmpty ? event.clubOrg : "Unknown Club";
    final boardTitle = event.board.isNotEmpty ? event.board : "IIT Guwahati";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'Posted By',
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.s),
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: OColor.gray200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                TablerIcons.users_group,
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
                    text: clubTitle,
                    style: OTextStyle.labelSmall.copyWith(
                      color: OColor.gray800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OText(
                    text: boardTitle,
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

  /// POCs section with contact avatars (horizontally scrollable)
  Widget _buildPOCs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OText(
          text: 'POCs',
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
        ),
        const SizedBox(height: OSpacing.s),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                event.poc.map((poc) {
                  return Padding(
                    padding: const EdgeInsets.only(right: OSpacing.l),
                    child: _buildProfileChip(
                      context: context,
                      name: poc.name ?? 'POC',
                      subtitle: poc.position ?? 'Events Head',
                      number: poc.number,
                      email: poc.email,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  /// A single profile chip: avatar circle + name + subtitle, stacked vertically
  Widget _buildProfileChip({
    BuildContext? context,
    required String name,
    required String subtitle,
    String? photoUrl,
    String? number,
    String? email,
  }) {
    return GestureDetector(
      onTap: () {
        if (context != null) {
          showPOCModal(
            context,
            name: name,
            subtitle: subtitle,
            number: number,
            email: email,
          );
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
              decoration: BoxDecoration(
                color: OColor.blue100,
                shape: BoxShape.circle,
              ),
              child:
                  photoUrl != null && photoUrl.isNotEmpty
                      ? EventNetworkImage.avatar(
                        imageUrl: photoUrl,
                        width: 48,
                        height: 48,
                      )
                      : Icon(TablerIcons.user, size: 32, color: OColor.blue500),
            ),
            const SizedBox(height: OSpacing.xs),
            OText(
              text: name,
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
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
      ),
    );
  }
}
