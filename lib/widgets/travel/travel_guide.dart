import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:onestop_dev/widgets/travel/about_travel.dart';
import 'package:onestop_dev/widgets/travel/travel_spot.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';



class TravelGuide extends StatefulWidget {
  const TravelGuide({super.key});

  @override
  State<TravelGuide> createState() => _TravelGuideState();
}

class _TravelGuideState extends State<TravelGuide> {
  final List<String> places = [
    "Airport",
    "Kamakhya Railway Station",
    "Guwahati Railway Station",
    "City Center Mall",
    "Kamakhya Temple",
    "Fancy Bazar",
    "Nehru Park"
  ];


  final List<IconData> icons = [

  FluentIcons.airplane_24_filled,
  FluentIcons.vehicle_subway_24_filled,
  FluentIcons.vehicle_subway_24_filled,
  FluentIcons.shopping_bag_24_filled,
  FluentIcons.building_24_filled,
  FluentIcons.cart_24_filled,
  FluentIcons.tree_deciduous_24_filled,

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: OColor.white,
        centerTitle: true,
        leadingWidth: 60,
        scrolledUnderElevation: 0,
        leading:
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: OColor.green600,
            ),
          onPressed: () {
            Navigator.of(context).pop();
              },
        ),
        title: OText(
          text: "Travel Guide",
          style: OTextStyle.headingMedium.copyWith(color: OColor.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TravelGuideInfoCard(),
              const SizedBox(height: 16),
              OText(
                text: "How to reach ?",
                textAlign: TextAlign.start,
                style: OTextStyle.headingMedium.copyWith(color: OColor.black),
              ),
              const SizedBox(height: 24),
              SpotButton(
                text: places[0],
                icon: icons[0],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[1],
                icon: icons[1],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[2],
                icon: icons[2],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[3],
                icon: icons[3],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[4],
                icon: icons[4],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[5],
                icon: icons[5],
              ),
              const SizedBox(height: 5),
              SpotButton(
                text: places[6],
                icon: icons[6],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


