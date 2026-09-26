import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_ui/index.dart';

/// Placeholder page for creating or editing an event.
///
/// When [event] is null, the page is in "Create" mode.
/// When [event] is provided, the page is in "Edit" mode.
/// TODO: Implement the full form UI matching the Figma design.
class CreateEditEventPage extends StatelessWidget {
  static const id = "/events/create-edit";

  final EventModel? event;

  const CreateEditEventPage({
    super.key,
    this.event,
  });

  bool get isEditing => event != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.white,
      appBar: OAppBar(
        title: isEditing ? 'Edit Event' : 'Create Event',
        isProgressive: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(OSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: OColor.green100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isEditing
                      ? FluentIcons.edit_24_regular
                      : FluentIcons.add_circle_24_regular,
                  size: 40,
                  color: OColor.green600,
                ),
              ),
              const SizedBox(height: OSpacing.l),
              OText(
                text: isEditing ? 'Edit Event' : 'Create New Event',
                style: OTextStyle.headingMedium.copyWith(
                  color: OColor.gray800,
                ),
              ),
              const SizedBox(height: OSpacing.xs),
              OText(
                text: 'This feature is coming soon.\nThe event form will be available in a future update.',
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              if (isEditing) ...[
                const SizedBox(height: OSpacing.s),
                OText(
                  text: 'Editing: ${event!.name}',
                  style: OTextStyle.labelSmall.copyWith(
                    color: OColor.blue500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: OSpacing.l),
              SecondaryButton(
                label: 'Go Back',
                onPressed: () => Navigator.of(context).pop(),
                leadingIcon: FluentIcons.arrow_left_16_regular,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
