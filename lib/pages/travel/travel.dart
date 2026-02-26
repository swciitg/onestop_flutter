import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/food/get_day.dart';
import 'package:onestop_dev/functions/travel/duration_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/pages/travel/bus_timings_page.dart';
import 'package:onestop_dev/pages/travel/ferry_timings_page.dart';
import 'package:onestop_dev/pages/services/cab_share.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/travel_guide.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    var mapStore = context.read<MapBoxStore>();
    mapStore.checkTravelPage(true);

    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dayNum = now.day;
    final month = DateFormat('MMMM').format(now);
    String suffix = 'th';
    if (dayNum == 1 || dayNum == 21 || dayNum == 31) {
      suffix = 'st';
    } else if (dayNum == 2 || dayNum == 22) {
      suffix = 'nd';
    } else if (dayNum == 3 || dayNum == 23) {
      suffix = 'rd';
    }
    final dateString = '$dayName, $dayNum$suffix $month';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Travel', style: OTextStyle.headingLarge.copyWith(color: OColor.gray800)),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  dateString,
                  style: OTextStyle.headingSmall.copyWith(color: OColor.green600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bus Summary Card
          _TimingSummaryCard(
            type: 'Bus',
            icon: FluentIcons.vehicle_bus_24_filled,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BusTimingsPage()),
              );
            },
          ),
          const SizedBox(height: 16),

          // Ferry Summary Card
          _TimingSummaryCard(
            type: 'Ferry',
            icon: FluentIcons.vehicle_ship_24_filled,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FerryTimingsPage()),
              );
            },
          ),
          const SizedBox(height: 32),

          // More Travel Options
          Text(
            'More Travel Options',
            style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
          ),
          const SizedBox(height: 16),

          // Travel Guide tile
          _OptionTile(
            icon: FluentIcons.book_24_filled,
            title: 'Travel Guide',
            subtitle: 'A quick guide to common travel methods, fares, and essential info.',
            trailing: Icon(Icons.chevron_right, color: OColor.gray600, size: 24),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelGuide()));
            },
          ),
          const SizedBox(height: 16),

          // Cab Sharing tile
          _OptionTile(
            icon: FluentIcons.vehicle_car_24_filled,
            title: 'Cab Sharing',
            subtitle: 'Connect with fellow students for shared cab rides.',
            trailing: Icon(Icons.arrow_outward, color: OColor.gray600, size: 24),
            onTap: () {
              Navigator.pushNamed(context, CabShare.id);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _TimingSummaryCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final VoidCallback onTap;

  const _TimingSummaryCard({required this.type, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final travelStore = context.read<TravelStore>();
    final isBus = type == 'Bus';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: OColor.green100,
                    borderRadius: BorderRadius.circular(OCornerRadius.s),
                  ),
                  child: Icon(icon, color: OColor.green600, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(type, style: OTextStyle.headingSmall.copyWith(color: OColor.gray800)),
                ),
                Icon(Icons.chevron_right, color: OColor.gray600, size: 16),
              ],
            ),
            const SizedBox(height: 16),

            // Direction summaries from API
            FutureBuilder<List<TravelTiming>>(
              future: isBus ? travelStore.getBusTimings() : travelStore.getFerryTimings(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return _buildDirectionSummary(snapshot.data!, isBus);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionSummary(List<TravelTiming> timings, bool isBus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IIT → City
        _DirectionRow(label: 'IIT', destination: 'City'),
        const SizedBox(height: 4),
        if (isBus)
          _BusSummaryRow(timings: timings, fromCampus: true)
        else
          _FerrySummaryRows(timings: timings, fromCampus: true),
        const SizedBox(height: 12),
        Divider(color: OColor.gray200, height: 1),
        const SizedBox(height: 12),
        // City → IIT
        _DirectionRow(label: 'City', destination: 'IIT'),
        const SizedBox(height: 4),
        if (isBus)
          _BusSummaryRow(timings: timings, fromCampus: false)
        else
          _FerrySummaryRows(timings: timings, fromCampus: false),
      ],
    );
  }
}

class _DirectionRow extends StatelessWidget {
  final String label;
  final String destination;

  const _DirectionRow({required this.label, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
        const SizedBox(width: 4),
        Icon(Icons.arrow_forward, size: 18, color: OColor.gray800),
        const SizedBox(width: 4),
        Text(destination, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
      ],
    );
  }
}

class _BusSummaryRow extends StatelessWidget {
  final List<TravelTiming> timings;
  final bool fromCampus;

  const _BusSummaryRow({required this.timings, required this.fromCampus});

  @override
  Widget build(BuildContext context) {
    if (timings.isEmpty) return const SizedBox();
    final today = getFormattedDay();
    final isWeekend = today == 'Sat' || today == 'Sun';

    List<DateTime> allTimes = [];
    String stopName = timings.first.stop;
    for (var t in timings) {
      final dayType = isWeekend ? t.weekend : t.weekdays;
      final times = fromCampus ? dayType.fromCampus : dayType.toCampus;
      allTimes.addAll(times);
      if (times.isNotEmpty) stopName = t.stop;
    }
    allTimes.sort((a, b) => a.compareTo(b));

    String timeText = '';
    if (allTimes.isNotEmpty) {
      final next = nextTime(allTimes);
      timeText = durationLeft(next);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(stopName.toUpperCase(), style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600)),
        _TimeBadge(text: timeText),
      ],
    );
  }
}

class _FerrySummaryRows extends StatelessWidget {
  final List<TravelTiming> timings;
  final bool fromCampus;

  const _FerrySummaryRows({required this.timings, required this.fromCampus});

  @override
  Widget build(BuildContext context) {
    final today = getFormattedDay();
    final isWeekend = today == 'Sun';

    return Column(
      children:
          timings.map((t) {
            final dayType = isWeekend ? t.weekend : t.weekdays;
            final times = fromCampus ? dayType.fromCampus : dayType.toCampus;

            String timeText = '';
            if (times.isNotEmpty) {
              final sortedTimes = List<DateTime>.from(times)..sort((a, b) => a.compareTo(b));
              final next = nextTime(sortedTimes);
              timeText = durationLeft(next);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.stop.toUpperCase(),
                    style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600),
                  ),
                  _TimeBadge(text: timeText),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  final String text;

  const _TimeBadge({required this.text});

  Color _getTimeColor(String text) {
    if (text.contains('min')) {
      final mins = int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 60;
      if (mins <= 10) return const Color(0xFFDE1135);
      if (mins <= 20) return const Color(0xFFC38509);
      return OColor.green600;
    }
    return OColor.green600;
  }

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox();
    final color = _getTimeColor(text);
    return RichText(
      text: TextSpan(
        style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
        children: [
          const TextSpan(text: 'In '),
          TextSpan(text: text, style: OTextStyle.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: OColor.gray800, size: 24),
                      const SizedBox(width: 8),
                      Text(title, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle, style: OTextStyle.bodySmall.copyWith(color: OColor.gray600)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
