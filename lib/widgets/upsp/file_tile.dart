import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class FileTile extends StatelessWidget {
  const FileTile({super.key, required this.filename, required this.onDelete});
  final Function onDelete;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.image_16_regular, size: 20, color: OColor.gray600),
          const SizedBox(width: OSpacing.xs),
          Expanded(
            child: Text(
              filename,
              style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          GestureDetector(
            onTap: () => onDelete(),
            child: Icon(FluentIcons.dismiss_16_regular, size: 20, color: OColor.gray600),
          ),
        ],
      ),
    );
  }
}
