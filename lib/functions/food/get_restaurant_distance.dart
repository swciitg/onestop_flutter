import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onestop_dev/functions/travel/distance.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

String getRestaurantDistance(BuildContext context, RestaurantModel restaurant) {
  try {
    return '${calculateDistance(
        context.read<MapBoxStore>().userLatLng,
        LatLng(restaurant.latitude,
            restaurant.longitude))
        .toStringAsFixed(2)} km';
  } catch (e) {
    return '';
  }
}