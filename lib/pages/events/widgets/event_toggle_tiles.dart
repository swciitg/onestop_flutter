import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:onestop_ui/index.dart';

/// Two side-by-side toggle tiles: "All Events" and "Saved Events".
///
/// Matches the Figma design's toggle tile row at the top of the Events homepage.

class ToggleButtons extends StatelessWidget {
  final VoidCallback? onTapTile1;
  final VoidCallback? onTapTile2;
  final String label1;
  final String label2;
  final IconData icon1;
  final IconData icon2;

  const ToggleButtons({
    super.key,
    required this.label1,
    required this.label2,
    required this.icon1,
    required this.icon2,
    this.onTapTile1,
    this.onTapTile2,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTile(icon: icon1, label: label1, onTap: onTapTile1),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTile(icon: icon2, label: label2, onTap: onTapTile2),
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
