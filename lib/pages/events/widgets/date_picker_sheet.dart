import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_ui/index.dart';

import 'sheet_header.dart';

/// Shows a month calendar in a bottom sheet. Returns the picked day, or null
/// if dismissed.
Future<DateTime?> showDatePickerSheet(
  BuildContext context, {
  required String title,
  DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColor.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => _DatePickerSheet(
      title: title,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class _DatePickerSheet extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _DatePickerSheet({
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  static const _weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sat', 'Su'];

  late DateTime _selected = _dateOnly(widget.initialDate);
  late DateTime _month = DateTime(_selected.year, _selected.month);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _inRange(DateTime d) =>
      !d.isBefore(_dateOnly(widget.firstDate)) &&
      !d.isAfter(_dateOnly(widget.lastDate));

  bool get _canGoBack =>
      DateTime(_month.year, _month.month, 0)
          .isAfter(_dateOnly(widget.firstDate));

  bool get _canGoForward =>
      DateTime(_month.year, _month.month + 1)
          .isBefore(_dateOnly(widget.lastDate).add(const Duration(days: 1)));

  void _changeMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  /// Days shown for [_month], padded to whole Monday-first weeks.
  List<DateTime> get _days {
    final first = DateTime(_month.year, _month.month);
    final last = DateTime(_month.year, _month.month + 1, 0);
    final start = first.subtract(Duration(days: first.weekday - 1));
    final end = last.add(Duration(days: 7 - last.weekday));
    return [
      for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) d,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(
              icon: FluentIcons.calendar_32_regular,
              title: widget.title,
            ),
            const SizedBox(height: OSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MonthArrow(
                  icon: FluentIcons.chevron_left_32_regular,
                  onTap: _canGoBack ? () => _changeMonth(-1) : null,
                ),
                OText(
                  text: DateFormat('MMMM yyyy').format(_month),
                  style: OTextStyle.labelMedium.copyWith(
                    color: OColor.gray800,
                  ),
                ),
                _MonthArrow(
                  icon: FluentIcons.chevron_right_32_regular,
                  onTap: _canGoForward ? () => _changeMonth(1) : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final w in _weekdays)
                  _Cell(label: w, color: OColor.gray800),
              ],
            ),
            for (var r = 0; r < days.length ~/ 7; r++)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final d in days.skip(r * 7).take(7))
                      _Cell(
                        label: '${d.day}',
                        selected: d == _selected,
                        color:
                            d.month != _month.month || !_inRange(d)
                                ? OColor.gray600
                                : OColor.gray800,
                        onTap:
                            _inRange(d)
                                ? () => setState(() {
                                  _selected = d;
                                  _month = DateTime(d.year, d.month);
                                })
                                : null,
                      ),
                  ],
                ),
              ),
            const SizedBox(height: OSpacing.l),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
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

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MonthArrow({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: 32,
        color: onTap == null ? OColor.gray400 : OColor.gray800,
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  const _Cell({
    required this.label,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? OColor.green600 : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: OText(
          text: label,
          style: OTextStyle.labelSmall.copyWith(
            color: selected ? OColor.white : color,
          ),
        ),
      ),
    );
  }
}
