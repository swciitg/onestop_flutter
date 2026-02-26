import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/travel/travel_guide_model.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/about_travel.dart';
import 'package:onestop_dev/widgets/travel/travel_spot.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class TravelGuide extends StatefulWidget {
  const TravelGuide({super.key});

  @override
  State<TravelGuide> createState() => _TravelGuideState();
}

class _TravelGuideState extends State<TravelGuide> {
  static IconData _iconForType(String iconType) {
    switch (iconType) {
      case 'airplane':
        return FluentIcons.airplane_24_filled;
      case 'train':
        return FluentIcons.vehicle_subway_24_filled;
      case 'shopping':
        return FluentIcons.shopping_bag_24_filled;
      case 'temple':
        return FluentIcons.building_24_filled;
      case 'market':
        return FluentIcons.cart_24_filled;
      case 'park':
        return FluentIcons.tree_deciduous_24_filled;
      case 'hospital':
        return FluentIcons.building_24_filled;
      case 'bus':
        return FluentIcons.vehicle_bus_24_filled;
      default:
        return FluentIcons.location_24_filled;
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
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: OColor.green600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Travel Guide',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<TravelGuideModel>>(
          future: travelStore.getTravelGuides(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final guides = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const TravelGuideInfoCard(),
                  const SizedBox(height: 16),
                  Text(
                    'How to reach?',
                    style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                  ),
                  const SizedBox(height: 16),
                  ...guides.map(
                    (guide) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SpotButton(guide: guide, icon: _iconForType(guide.iconType)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
