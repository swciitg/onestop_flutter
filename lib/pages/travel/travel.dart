import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:onestop_dev/widgets/travel/ferry_details.dart';
import 'package:onestop_dev/widgets/travel/next_time_card.dart';
import 'package:onestop_dev/widgets/travel/stops_bus_details.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';
import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  int selectBusesOrStops = 0;

  @override
  Widget build(BuildContext context) {
    final mapStore = context.read<MapBoxStore>();
    mapStore.checkTravelPage(true);

    // ✅ Dynamic localized date
    final formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Travel', style: MyFonts.w600.size(24)),
              const SizedBox(width: 16),
              Text(
                formattedDate,
                style: MyFonts.w600.size(16).setColor(kDarkGreen),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                tooltip: 'Notifications',
                icon: const Icon(CupertinoIcons.bell, size: 32, color: kDarkGreen),
              ),
            ],
          ),
          const SizedBox(height: 30),

          _TravelCard(
            iconPath: 'assets/images/bus.png',
            title: 'Bus',
            onTap: () {
              // TODO: navigate to Bus details page
            },
            routes: [
              _TravelRoute('IIT', 'City', [
                kBusStopTimeTile('tic bus stop', '54', kDarkGreen),
              ]),
              _TravelRoute('City', 'IIT', [
                kBusStopTimeTile('Nehru park', '5', kRed),
              ]),
            ],
          ),
          const SizedBox(height: 40),
          _TravelCard(
            iconPath: 'assets/images/ship.png',
            title: 'Ferry',
            onTap: () {
              // TODO: navigate to Ferry details page
            },
            routes: [
              _TravelRoute('IIT', 'City', [
                kBusStopTimeTile('tic bus stop', '24', kDarkGreen),
                kBusStopTimeTile('Madhyamkhanda', '4', kRed),
                kBusStopTimeTile('Rajadwar', '15', kYellowDullColor.withOpacity(0.9)),
              ]),
              _TravelRoute('City', 'IIT', [
                kBusStopTimeTile('tic bus stop', '24', kRed),
                kBusStopTimeTile('Madhyamkhanda', '4', kDarkGreen),
                kBusStopTimeTile('Rajadwar', '15', kDarkGreen),
              ]),
            ],
          ),

          const SizedBox(height: 50),
          Text('More Travel Options', style: MyFonts.w600.size(24)),
          const SizedBox(height: 16),

          // ✅ Added InkWell + semantics for interactivity
          _OptionCard(
            iconPath: 'assets/images/avatars.png',
            title: 'Administration',
            onTap: () {
              // TODO: navigate to Administration page
            },
          ),
          const SizedBox(height: 16),
          _OptionCard(
            iconPath: 'assets/images/book.png',
            title: 'Travel Guide',
            subtitle:
            'A quick guide to common travel methods, fares, and essential info.',
            onTap: () {
              // TODO: navigate to Travel Guide page
            },
          ),
          const SizedBox(height: 16),
          _OptionCard(
            iconPath: 'assets/images/car.png',
            title: 'Cab Sharing',
            subtitle: 'Connect with fellow students for shared cab rides.',
            trailing: Transform.rotate(
              angle: 320 * 3.1415927 / 180,
              child: const Icon(Icons.arrow_forward, size: 18),
            ),
            onTap: () {
              // TODO: navigate to Cab Sharing page
            },
          ),
          const SizedBox(height: 40),

          // const SizedBox(height: 10),
          // const MapBox(),
          // const SizedBox(height: 10),
          // const NextTimeCard(),
          // const SizedBox(height: 10),
          // Observer(
          //   builder: (context) {
          //     return (mapStore.indexBusesorFerry == 0)
          //         ? const StopsBusDetails()
          //         : const FerryDetails();
          //   },
          // )
        ],
      ),
    );
  }

  static Row kBusStopTimeTile(String busStop, String time, Color color) {
    return Row(
      children: [
        Text(busStop.toUpperCase(),
            style: MyFonts.w500.size(14).setColor(kGrey7)),
        const Spacer(),
        Text('In', style: MyFonts.w500.size(14)),
        const SizedBox(width: 6),
        Text('$time mins',
            style: MyFonts.w500.size(14).setColor(color)),
      ],
    );
  }
}

class _TravelCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final List<_TravelRoute> routes;
  final VoidCallback onTap;

  const _TravelCard({
    required this.iconPath,
    required this.title,
    required this.routes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title travel section',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: kWhite,
            border: Border.all(color: kFontGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kDarkGreen.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      iconPath,
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.directions_bus, color: kDarkGreen),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: MyFonts.w600.size(16)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              for (final route in routes) ...[
                route.build(context),
                if (route != routes.last) const Divider(),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelRoute {
  final String from;
  final String to;
  final List<Widget> stops;

  _TravelRoute(this.from, this.to, this.stops);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(from, style: MyFonts.w600.size(16)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 14),
            const SizedBox(width: 8),
            Text(to, style: MyFonts.w600.size(16)),
          ],
        ),
        const SizedBox(height: 14),
        ...stops,
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _OptionCard({
    required this.iconPath,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title option',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: kWhite,
            border: Border.all(color: kFontGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: MyFonts.w600.size(16)),
                  ),
                  trailing ??
                      const Icon(Icons.arrow_forward_ios_outlined, size: 18),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: MyFonts.w500.size(14).setColor(kGrey7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
