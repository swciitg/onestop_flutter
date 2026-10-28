import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_ui/index.dart';

/// Two side-by-side toggle tiles: "All Events" and "Saved Events".
///
/// Matches the Figma design's toggle tile row at the top of the Events homepage.
class EventToggleTiles extends StatelessWidget {
  final VoidCallback? onAllEventsTap;
  final VoidCallback? onSavedEventsTap;

  const EventToggleTiles({
    super.key,
    this.onAllEventsTap,
    this.onSavedEventsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTile(
            icon: TablerIcons.list,
            label: 'All Events',
            onTap: onAllEventsTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTile(
            icon: TablerIcons.heart_plus,
            label: 'Saved Events',
            onTap: onSavedEventsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: OColor.green600),
              const SizedBox(width: OSpacing.xs),
              OText(
                text: label,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
