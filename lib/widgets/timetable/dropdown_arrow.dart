import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key, required this.showArrow, required this.toggle});
  final bool showArrow;
  final VoidCallback toggle;
  @override
  Widget build(BuildContext context) {
    if (showArrow) {
      return Observer(
        builder: (context) {
          return Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: () {
                toggle();
              },
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                  color: OColor.green100,
                ),
                child: Icon(
                  (!context.read<TimetableStore>().showDropDown)
                      ? FluentIcons.chevron_down_24_filled
                      : FluentIcons.chevron_up_24_filled,
                  color: OColor.green600,
                ),
              ),
            ),
          );
        },
      );
    }
    return const SizedBox();
  }
}
