import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/days.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

/// Date selector: "Date" button │ day pills  or  "Date" button │ picked-date pill.
class DateSlider extends StatelessWidget {
  final DateTime? pickedDate;
  final VoidCallback onDateButtonTap;
  final VoidCallback onClearPickedDate;

  const DateSlider({
    super.key,
    this.pickedDate,
    required this.onDateButtonTap,
    required this.onClearPickedDate,
  });

  @override
  Widget build(BuildContext context) {
    final ttStore = context.read<TimetableStore>();
    ttStore.initialiseDates();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
      child: Row(
        children: [
          // "Date" button
          _DateButton(onTap: onDateButtonTap),
          // Vertical separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            child: Container(width: 1, height: 40, color: OColor.gray300),
          ),
          // Picked-date pill  or  scrollable day pills
          if (pickedDate != null)
            Flexible(child: _PickedDatePill(date: pickedDate!, onClear: onClearPickedDate))
          else
            Expanded(child: _DayPillsList(ttStore: ttStore)),
        ],
      ),
    );
  }
}

// ─── Outlined "Date" button with calendar icon ───────────────────────────

class _DateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.l, vertical: OSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: OColor.green600),
            const SizedBox(width: OSpacing.xxs),
            Text('Date', style: OTextStyle.labelSmall.copyWith(color: OColor.green600)),
          ],
        ),
      ),
    );
  }
}

// ─── Green pill showing the selected date with ✕ ────────────────────────

class _PickedDatePill extends StatelessWidget {
  final DateTime date;
  final VoidCallback onClear;
  const _PickedDatePill({required this.date, required this.onClear});

  String _formatDate() {
    final dayName = DateFormat.EEEE().format(date);
    final month = DateFormat.MMMM().format(date);
    return '$dayName, ${_ordinal(date.day)} $month';
  }

  static String _ordinal(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.l, vertical: OSpacing.xs),
      decoration: BoxDecoration(
        color: OColor.green600,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              _formatDate(),
              style: OTextStyle.labelSmall.copyWith(color: OColor.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: OSpacing.xxs),
          GestureDetector(onTap: onClear, child: Icon(Icons.close, size: 16, color: OColor.white)),
        ],
      ),
    );
  }
}

// ─── Horizontal scrollable day pills ─────────────────────────────────────

class _DayPillsList extends StatelessWidget {
  final TimetableStore ttStore;
  const _DayPillsList({required this.ttStore});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: OSpacing.xs),
          child: GestureDetector(
            onTap: () {
              ttStore.setDate(index);
              ttStore.setDay(ttStore.dates[index].weekday - 1);
            },
            child: Observer(
              builder: (context) {
                final bool selected = ttStore.selectedDate == index;
                final DateTime date = ttStore.dates[index];
                final String dayName = kday[date.weekday]!;
                final String monthDay =
                    '${date.day} ${DateFormat.MMM().format(date).toUpperCase()}';

                return Container(
                  constraints: const BoxConstraints(minWidth: 72),
                  height: 56,
                  padding: const EdgeInsets.symmetric(
                    horizontal: OSpacing.m,
                    vertical: OSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? OColor.green600 : OColor.white,
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                    border: selected ? null : Border.all(color: OColor.gray300),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: OTextStyle.labelSmall.copyWith(
                          color: selected ? OColor.white : OColor.gray800,
                        ),
                      ),
                      Text(
                        monthDay,
                        style: OTextStyle.labelXSmall.copyWith(
                          color: selected ? OColor.white : OColor.gray600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
