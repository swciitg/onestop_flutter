import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/food/restaurant_model.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/widgets/food/mess/mess_menu.dart';
import 'package:onestop_dev/widgets/food/outlets_filter.dart';
import 'package:onestop_dev/widgets/food/restaurant/restaurant_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_ui/index.dart';

class FoodTab extends StatefulWidget {
  const FoodTab({super.key});

  @override
  State<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RestaurantModel> _filterRestaurants(List<RestaurantModel> restaurants) {
    if (_searchQuery.isEmpty) return restaurants;
    final query = _searchQuery.toLowerCase();
    return restaurants.where((r) {
      return r.outletName.toLowerCase().contains(query) ||
          r.caption.toLowerCase().contains(query) ||
          r.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessMenu(),
                    const SizedBox(height: 8),
                    const OutletsFilter(),
                    const SizedBox(height: 8),
                    // Search bar
                    _buildSearchBar(),
                    const SizedBox(height: 8),
                    FutureBuilder<List<RestaurantModel>>(
                      future: DataService.getRestaurants(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<RestaurantModel>> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          final filtered = _filterRestaurants(snapshot.data!);
                          if (filtered.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text(
                                  'No outlets found',
                                  style: OTextStyle.bodyMedium.copyWith(color: OColor.gray400),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children:
                                filtered
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: RestaurantTile(restaurantModel: e),
                                      ),
                                    )
                                    .toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "An error occurred",
                              style: OTextStyle.headingMedium.copyWith(
                                fontSize: 25,
                                color: OColor.gray800,
                              ),
                            ),
                          );
                        }
                        return Center(child: ListShimmer(height: 168));
                      },
                    ),
                    const SizedBox(height: 160),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildSearchBar() {
    return Container(
                    decoration: BoxDecoration(
                      color: OColor.white,
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                      border: Border.all(color: OColor.gray200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                      decoration: InputDecoration(
                        hintText: 'Search food outlets...',
                        hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
                        prefixIcon: Icon(
                          FluentIcons.search_24_regular,
                          color: OColor.gray400,
                          size: 20,
                        ),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                  child: Icon(
                                    FluentIcons.dismiss_24_regular,
                                    color: OColor.gray400,
                                    size: 20,
                                  ),
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        isDense: true,
                      ),
                    ),
                  );
  }
}
