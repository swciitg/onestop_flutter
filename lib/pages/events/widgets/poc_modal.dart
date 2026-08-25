import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Shows the POC modal as a bottom sheet.
void showPOCModal(BuildContext context, {required String name, required String subtitle}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _POCModalContent(name: name, subtitle: subtitle);
    },
  );
}

class _POCModalContent extends StatelessWidget {
  final String name;
  final String subtitle;

  const _POCModalContent({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        border: Border.all(color: OColor.gray200),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + "Contact" + close button
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: OColor.green100, shape: BoxShape.circle),
                child: Icon(FluentIcons.person_24_regular, size: 20, color: OColor.green600),
              ),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: OText(
                  text: 'Contact',
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

          // Profile: avatar + name
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: OColor.blue100,
                child: Icon(FluentIcons.person_24_regular, color: OColor.blue500, size: 24),
              ),
              const SizedBox(width: OSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OText(
                      text: name,
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    OText(
                      text: subtitle,
                      style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.l),

          // Contact info rows
          Row(
            children: [
              Icon(FluentIcons.call_24_regular, size: 16, color: OColor.gray500),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: OText(
                  text: "+91123456789", // Mock data
                  style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                ),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.xs),
          Row(
            children: [
              Icon(FluentIcons.mail_24_regular, size: 16, color: OColor.gray500),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: OText(
                  text: "adoiisi@iitg.ac.in", // Mock data
                  style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                ),
              ),
            ],
          ),
          const SizedBox(height: OSpacing.l),

          // Action buttons: Call / Text / Mail
          Row(
            children: [
              Expanded(
                child: _buildActionButton(icon: FluentIcons.call_16_regular, label: 'Call', onTap: () {}),
              ),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: _buildActionButton(icon: FluentIcons.chat_16_regular, label: 'Text', onTap: () {}),
              ),
              const SizedBox(width: OSpacing.xs),
              Expanded(
                child: _buildActionButton(icon: FluentIcons.mail_16_regular, label: 'Mail', onTap: () {}),
              ),
            ],
          ),
          // Add safe area for bottom
          const SafeArea(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: OColor.green600),
            const SizedBox(width: OSpacing.xxs),
            OText(
              text: label,
              style: OTextStyle.labelMedium.copyWith(color: OColor.green600),
            ),
          ],
        ),
      ),
    );
  }
}
