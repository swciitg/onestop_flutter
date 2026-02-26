import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';
import 'package:onestop_dev/functions/travel/next_time.dart';
import 'package:onestop_dev/models/travel/travel_timing_model.dart';
import 'package:onestop_dev/pages/travel/data.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/travel_guide.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FerryTimingsPage extends StatefulWidget {
  const FerryTimingsPage({super.key});

  @override
  State<FerryTimingsPage> createState() => _FerryTimingsPageState();
}

class _FerryTimingsPageState extends State<FerryTimingsPage> {
  bool _isWeekday = true;
  bool _fromCampus = true;
  bool _showGuideHint = true;
  int _selectedGhatIndex = 0;

  @override
  void initState() {
    super.initState();
    if (DateTime.now().weekday == DateTime.sunday) {
      _isWeekday = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelStore = context.read<TravelStore>();
    final mapStore = context.read<MapBoxStore>();

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: OColor.green600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Ferry Timings',
          style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
        ),
      ),
      body: FutureBuilder<List<TravelTiming>>(
        future: travelStore.getFerryTimings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final timings = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day type toggle
                _DayToggle(
                  isFirst: _isWeekday,
                  firstLabel: 'Rest of the Week',
                  secondLabel: 'Sunday',
                  onChanged: (val) => setState(() => _isWeekday = val),
                ),
                const SizedBox(height: 16),

                // Travel guide hint
                if (_showGuideHint)
                  _FerryGuideHint(
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
                  onSwap: () => setState(() => _fromCampus = !_fromCampus),
                ),
                const SizedBox(height: 16),

                // Ghat tabs
                _GhatTabs(
                  selectedIndex: _selectedGhatIndex,
                  onSelected:
                      (i) => setState(() {
                        _selectedGhatIndex = i;
                        travelStore.setFerryGhat(ferryGhats[i]['name'] as String);
                      }),
                ),
                const SizedBox(height: 16),

                // Map
                _GhatMap(ghat: ferryGhats[_selectedGhatIndex], mapStore: mapStore),
                const SizedBox(height: 8),

                // Directions link
                GestureDetector(
                  onTap: () {
                    final lat = ferryGhats[_selectedGhatIndex]['lat'];
                    final lng = ferryGhats[_selectedGhatIndex]['long'];
                    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
                    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Directions',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_outward, size: 14, color: OColor.green600),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Timing list
                _FerryTimingList(
                  timings: timings,
                  ghatName: ferryGhats[_selectedGhatIndex]['name'] as String,
                  isWeekday: _isWeekday,
                  fromCampus: _fromCampus,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Day toggle (reusable) ──────────────────────────────────────────────

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
          Expanded(child: _btn(firstLabel, isFirst, () => onChanged(true))),
          Expanded(child: _btn(secondLabel, !isFirst, () => onChanged(false))),
        ],
      ),
    );
  }

  Widget _btn(String label, bool selected, VoidCallback onTap) {
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

// ─── Ferry guide hint ───────────────────────────────────────────────────

class _FerryGuideHint extends StatefulWidget {
  final VoidCallback onHide;
  final VoidCallback onNavigate;

  const _FerryGuideHint({required this.onHide, required this.onNavigate});

  @override
  State<_FerryGuideHint> createState() => _FerryGuideHintState();
}

class _FerryGuideHintState extends State<_FerryGuideHint> {
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
                  child: Icon(
                    FluentIcons.vehicle_ship_24_filled,
                    color: OColor.green600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Travel by Ferry',
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
              'Ferries operate between IIT Guwahati campus and the Guwahati city ghats. They are the fastest way to reach the city from campus.',
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
                      'Timings may vary due to weather',
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
  final VoidCallback onSwap;

  const _DirectionSwitch({required this.fromCampus, required this.onSwap});

  @override
  Widget build(BuildContext context) {
    final from = fromCampus ? 'IIT' : 'City';
    final to = fromCampus ? 'City' : 'IIT';
    final fromSub = fromCampus ? 'Campus' : 'Guwahati';
    final toSub = fromCampus ? 'Guwahati' : 'Campus';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Row(
        children: [
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
          GestureDetector(
            onTap: onSwap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: OColor.green100, shape: BoxShape.circle),
              child: Icon(
                FluentIcons.arrow_swap_24_regular,
                size: 20,
                color: OColor.green600,
              ),
            ),
          ),
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

// ─── Ghat tabs ──────────────────────────────────────────────────────────

class _GhatTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _GhatTabs({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(ferryGhats.length, (i) {
        final name = ferryGhats[i]['name'] as String;
        final selected = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              margin: EdgeInsets.only(right: i < ferryGhats.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? OColor.green600 : OColor.white,
                borderRadius: BorderRadius.circular(OCornerRadius.xl),
                border: Border.all(color: selected ? OColor.green600 : OColor.gray200),
              ),
              child: Center(
                child: Text(
                  name,
                  style: OTextStyle.labelSmall.copyWith(
                    color: selected ? OColor.white : OColor.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Ghat map ───────────────────────────────────────────────────────────

class _GhatMap extends StatelessWidget {
  final Map<String, dynamic> ghat;
  final MapBoxStore mapStore;

  const _GhatMap({required this.ghat, required this.mapStore});

  @override
  Widget build(BuildContext context) {
    final lat = ghat['lat'] as double;
    final lng = ghat['long'] as double;
    final name = ghat['name'] as String;

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 14),
        markers: {
          Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
          ),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        liteModeEnabled: true,
      ),
    );
  }
}

// ─── Ferry timing list ──────────────────────────────────────────────────

class _FerryTimingList extends StatelessWidget {
  final List<TravelTiming> timings;
  final String ghatName;
  final bool isWeekday;
  final bool fromCampus;

  const _FerryTimingList({
    required this.timings,
    required this.ghatName,
    required this.isWeekday,
    required this.fromCampus,
  });

  @override
  Widget build(BuildContext context) {
    final ferryModel = timings.firstWhere((e) => e.stop == ghatName, orElse: () => timings.first);

    final dayType = isWeekday ? ferryModel.weekdays : ferryModel.weekend;
    final times = fromCampus ? dayType.fromCampus : dayType.toCampus;
    final sortedTimes = List<DateTime>.from(times)..sort((a, b) => a.compareTo(b));

    if (sortedTimes.isEmpty) {
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
          sortedTimes.map((time) {
            final timeStr = formatTime(time);
            final left = hasLeft(time);
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
                  Text(
                    timeStr,
                    style: OTextStyle.labelMedium.copyWith(
                      color: left ? OColor.gray400 : OColor.gray800,
                    ),
                  ),
                  const Spacer(),
                  if (left)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: OColor.gray100,
                        borderRadius: BorderRadius.circular(OCornerRadius.xl),
                      ),
                      child: Text(
                        'LEFT',
                        style: OTextStyle.labelXSmall.copyWith(color: OColor.gray400),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
