import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/stops_bus_details.dart';
import 'package:onestop_dev/widgets/travel/travel_guide.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class BusTimingsPage extends StatefulWidget {
  const BusTimingsPage({super.key});

  @override
  State<BusTimingsPage> createState() => _BusTimingsPageState();
}

class _BusTimingsPageState extends State<BusTimingsPage> {
  bool _isWeekday = true;
  bool _fromCampus = true;
  bool _showGuideHint = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      _isWeekday = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelStore = context.read<TravelStore>();

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 60,
        systemOverlayStyle: Theme.of(
          context,
        ).appBarTheme.systemOverlayStyle?.copyWith(statusBarColor: OColor.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: OColor.green600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Bus Timings', style: OTextStyle.headingSmall.copyWith(color: OColor.gray800)),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<TravelTiming>>(
            future: travelStore.getBusTimings(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final timings = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day type toggle
                    _DayToggle(
                      isFirst: _isWeekday,
                      firstLabel: 'Weekdays',
                      secondLabel: 'Weekends',
                      onChanged: (val) => setState(() => _isWeekday = val),
                    ),
                    const SizedBox(height: 16),

                    // Travel guide hint
                    if (_showGuideHint)
                      _TravelGuideHint(
                        onHide: () => setState(() => _showGuideHint = false),
                        onNavigate: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TravelGuide()),
                          );
                        },
                      ),
                    if (_showGuideHint) const SizedBox(height: 16),

                    // Direction switch
                    _DirectionSwitch(
                      fromCampus: _fromCampus,
                      leftLabel: 'City',
                      rightLabel: 'IIT',
                      leftSub: 'Jalukbari',
                      rightSub: 'Campus',
                      onSwap: () => setState(() => _fromCampus = !_fromCampus),
                    ),
                    const SizedBox(height: 16),

                    // Timing list
                    _BusTimingList(
                      timings: timings,
                      isWeekday: _isWeekday,
                      fromCampus: _fromCampus,
                    ),
                  ],
                ),
              );
            },
          ),

          // Sticky Track Bus button
          Positioned(
            right: 16,
            bottom: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(OCornerRadius.xl),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MilliTrack()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: OColor.green600,
                    borderRadius: BorderRadius.circular(OCornerRadius.l),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.vehicle_bus_24_filled, color: OColor.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Track Bus',
                        style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day type toggle ────────────────────────────────────────────────────

class _DayToggle extends StatelessWidget {
  final bool isFirst;
  final String firstLabel;
  final String secondLabel;
  final ValueChanged<bool> onChanged;

  const _DayToggle({
    required this.isFirst,
    required this.firstLabel,
    required this.secondLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.xl),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleBtn(firstLabel, isFirst, () => onChanged(true))),
          Expanded(child: _toggleBtn(secondLabel, !isFirst, () => onChanged(false))),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? OColor.green600 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
        ),
        child: Center(
          child: Text(
            label,
            style: OTextStyle.labelMedium.copyWith(color: selected ? OColor.white : OColor.gray600),
          ),
        ),
      ),
    );
  }
}

// ─── Travel guide hint ──────────────────────────────────────────────────

class _TravelGuideHint extends StatefulWidget {
  final VoidCallback onHide;
  final VoidCallback onNavigate;

  const _TravelGuideHint({required this.onHide, required this.onNavigate});

  @override
  State<_TravelGuideHint> createState() => _TravelGuideHintState();
}

class _TravelGuideHintState extends State<_TravelGuideHint> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: OColor.green100,
                    borderRadius: BorderRadius.circular(OCornerRadius.s),
                  ),
                  child: Icon(FluentIcons.vehicle_bus_24_filled, color: OColor.green600, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Travel by Green Valley Bus',
                    style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                  ),
                ),
                if (!_expanded)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? FluentIcons.chevron_up_24_regular
                      : FluentIcons.chevron_down_24_regular,
                  size: 18,
                  color: OColor.gray600,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 8),
            Text(
              'You can check the bus timings below. The Green Valley public bus plys between the IIT campus and the city.',
              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(OCornerRadius.s),
              ),
              child: Row(
                children: [
                  const Icon(FluentIcons.warning_24_regular, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please verify timings before travel',
                      style: OTextStyle.labelSmall.copyWith(color: const Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNavigate,
                  child: Row(
                    children: [
                      Text(
                        'Travel Guide',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_outward, size: 14, color: OColor.green600),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onHide,
                  child: Text('Hide', style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Direction switch ───────────────────────────────────────────────────

class _DirectionSwitch extends StatelessWidget {
  final bool fromCampus;
  final String leftLabel;
  final String rightLabel;
  final String leftSub;
  final String rightSub;
  final VoidCallback onSwap;

  const _DirectionSwitch({
    required this.fromCampus,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSub,
    required this.rightSub,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final from = fromCampus ? rightLabel : leftLabel;
    final to = fromCampus ? leftLabel : rightLabel;
    final fromSub = fromCampus ? rightSub : leftSub;
    final toSub = fromCampus ? leftSub : rightSub;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          // From
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(from, style: OTextStyle.headingSmall.copyWith(color: OColor.gray800)),
                const SizedBox(height: 2),
                Text(fromSub, style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600)),
              ],
            ),
          ),
          // Swap button
          GestureDetector(
            onTap: onSwap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: OColor.green100, shape: BoxShape.circle),
              child: Icon(FluentIcons.arrow_swap_24_regular, size: 20, color: OColor.green600),
            ),
          ),
          // To
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(to, style: OTextStyle.headingSmall.copyWith(color: OColor.gray800)),
                const SizedBox(height: 2),
                Text(toSub, style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bus timing list ────────────────────────────────────────────────────

class _BusTimingList extends StatelessWidget {
  final List<TravelTiming> timings;
  final bool isWeekday;
  final bool fromCampus;

  const _BusTimingList({required this.timings, required this.isWeekday, required this.fromCampus});

  @override
  Widget build(BuildContext context) {
    // Collect all times across stops
    final List<_TimingEntry> entries = [];
    for (var t in timings) {
      final dayType = isWeekday ? t.weekdays : t.weekend;
      final times = fromCampus ? dayType.fromCampus : dayType.toCampus;
      for (var time in times) {
        entries.add(_TimingEntry(time: time, stopName: t.stop, left: hasLeft(time)));
      }
    }
    entries.sort(
      (a, b) => (a.time.hour * 60 + a.time.minute).compareTo(b.time.hour * 60 + b.time.minute),
    );

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No timings available',
            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
          ),
        ),
      );
    }

    return Column(
      children:
          entries.map((e) {
            final timeStr = formatTime(e.time);
            return _TimingCard(timeStr: timeStr, stopName: e.stopName, hasLeft: e.left);
          }).toList(),
    );
  }
}

class _TimingEntry {
  final DateTime time;
  final String stopName;
  final bool left;

  _TimingEntry({required this.time, required this.stopName, required this.left});
}

class _TimingCard extends StatelessWidget {
  final String timeStr;
  final String stopName;
  final bool hasLeft;

  const _TimingCard({required this.timeStr, required this.stopName, required this.hasLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
          // Time
          Text(
            timeStr,
            style: OTextStyle.labelMedium.copyWith(
              color: hasLeft ? OColor.gray400 : OColor.gray800,
            ),
          ),
          const SizedBox(width: 8),
          Text(stopName, style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400)),
          const Spacer(),
          if (hasLeft)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: OColor.gray100,
                borderRadius: BorderRadius.circular(OCornerRadius.xl),
              ),
              child: Text('LEFT', style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400)),
            )
          else
            _StatusBadge(time: timeStr),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String time;

  const _StatusBadge({required this.time});

  @override
  Widget build(BuildContext context) {
    // Parse time to compute duration
    try {
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final min = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final now = DateTime.now();
      var target = DateTime(now.year, now.month, now.day, hour, min);
      if (target.isBefore(now)) target = target.add(const Duration(days: 1));
      final diff = target.difference(now);

      String label;
      Color bgColor;
      Color textColor;

      if (diff.inMinutes <= 10) {
        label = 'IN ${diff.inMinutes} MIN';
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDE1135);
      } else if (diff.inMinutes <= 30) {
        label = 'IN ${diff.inMinutes} MIN';
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFC38509);
      } else if (diff.inHours < 1) {
        label = 'IN ${diff.inMinutes} MIN';
        bgColor = const Color(0xFFD1FAE5);
        textColor = OColor.green600;
      } else {
        label = 'IN ${diff.inHours} HR';
        bgColor = const Color(0xFFD1FAE5);
        textColor = OColor.green600;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
        ),
        child: Text(label, style: OTextStyle.labelXSmall.copyWith(color: textColor)),
      );
    } catch (_) {
      return const SizedBox();
    }
  }
}
