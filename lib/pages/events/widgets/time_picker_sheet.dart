import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

import 'sheet_header.dart';

/// Shows a scrollable hour / minute / AM-PM picker in a bottom sheet.
/// Returns the picked time, or null if dismissed.
Future<TimeOfDay?> showTimePickerSheet(
  BuildContext context, {
  required String title,
  TimeOfDay? initialTime,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: OColor.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => _TimePickerSheet(
      title: title,
      initialTime: initialTime ?? TimeOfDay.now(),
    ),
  );
}

class _TimePickerSheet extends StatefulWidget {
  final String title;
  final TimeOfDay initialTime;

  const _TimePickerSheet({required this.title, required this.initialTime});

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _hour; // 1..12
  late int _minute; // 0..59
  late bool _isPm;

  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;
  late final FixedExtentScrollController _periodCtrl;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTime;
    _hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    _minute = t.minute;
    _isPm = t.period == DayPeriod.pm;
    _hourCtrl = FixedExtentScrollController(initialItem: _hour - 1);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
    _periodCtrl = FixedExtentScrollController(initialItem: _isPm ? 1 : 0);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    _periodCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final h = (_hour % 12) + (_isPm ? 12 : 0);
    Navigator.pop(context, TimeOfDay(hour: h, minute: _minute));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(
              icon: FluentIcons.clock_32_regular,
              title: widget.title,
            ),
            const SizedBox(height: OSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Wheel(
                  controller: _hourCtrl,
                  count: 12,
                  loop: true,
                  labelFor: (i) => (i + 1).toString().padLeft(2, '0'),
                  onChanged: (i) => _hour = i + 1,
                ),
                const SizedBox(width: OSpacing.m),
                OText(
                  text: ':',
                  style: OTextStyle.headingLarge.copyWith(
                    fontSize: 40,
                    color: OColor.gray800,
                  ),
                ),
                const SizedBox(width: OSpacing.m),
                _Wheel(
                  controller: _minuteCtrl,
                  count: 60,
                  loop: true,
                  labelFor: (i) => i.toString().padLeft(2, '0'),
                  onChanged: (i) => _minute = i,
                ),
                const SizedBox(width: OSpacing.m),
                _Wheel(
                  controller: _periodCtrl,
                  count: 2,
                  loop: false,
                  labelFor: (i) => i == 0 ? 'AM' : 'PM',
                  onChanged: (i) => _isPm = i == 1,
                ),
              ],
            ),
            const SizedBox(height: OSpacing.l),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: OColor.green600,
                  foregroundColor: OColor.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                  ),
                ),
                child: OText(
                  text: 'Select',
                  style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One scrollable column: chevron-up, wheel (prev / selected / next),
/// chevron-down. The chevrons step the wheel by one item.
class _Wheel extends StatefulWidget {
  final FixedExtentScrollController controller;
  final int count;
  final bool loop;
  final String Function(int index) labelFor;
  final ValueChanged<int> onChanged;

  const _Wheel({
    required this.controller,
    required this.count,
    required this.loop,
    required this.labelFor,
    required this.onChanged,
  });

  @override
  State<_Wheel> createState() => _WheelState();
}

class _WheelState extends State<_Wheel> {
  static const _itemExtent = 44.0;
  late int _selected = widget.controller.initialItem % widget.count;

  void _step(int delta) {
    final target = widget.controller.selectedItem + delta;
    if (!widget.loop && (target < 0 || target >= widget.count)) return;
    widget.controller.animateToItem(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Widget _item(int index) {
    final i = index % widget.count;
    final selected = i == _selected;
    return Center(
      child: OText(
        text: widget.labelFor(i),
        style: selected
            ? OTextStyle.headingLarge.copyWith(
                fontSize: 36,
                height: 44 / 36,
                color: OColor.gray800,
              )
            : OTextStyle.headingSmall.copyWith(color: OColor.gray400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _step(-1),
          behavior: HitTestBehavior.opaque,
          child: Icon(
            FluentIcons.chevron_up_24_regular,
            size: 24,
            color: OColor.gray800,
          ),
        ),
        SizedBox(
          width: 72,
          height: _itemExtent * 3,
          child: ListWheelScrollView.useDelegate(
            controller: widget.controller,
            itemExtent: _itemExtent,
            perspective: 0.0001,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              final i = index % widget.count;
              widget.onChanged(i);
              setState(() => _selected = i);
            },
            childDelegate: widget.loop
                ? ListWheelChildLoopingListDelegate(
                    children: [
                      for (var i = 0; i < widget.count; i++) _item(i),
                    ],
                  )
                : ListWheelChildBuilderDelegate(
                    childCount: widget.count,
                    builder: (_, index) => _item(index),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () => _step(1),
          behavior: HitTestBehavior.opaque,
          child: Icon(
            FluentIcons.chevron_down_24_regular,
            size: 24,
            color: OColor.gray800,
          ),
        ),
      ],
    );
  }
}
