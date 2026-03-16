import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mess_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/food/mess_menu_model.dart';

class MessMenu extends StatelessWidget {
  MessMenu({super.key});

  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  final List<String> hostels =
      Mess.values.displayStrings().where((e) => e != Mess.none.displayString).toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Provider(
      create: (_) {
        final store = MessStore();
        store.setMess(
          OneStopUser.fromJson(LoginStore.userData).subscribedMess?.getMessFromDatabaseString() ??
              store.defaultUserMess,
        );
        return store;
      },
      builder: (context, _) {
        final messStore = context.read<MessStore>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, screenWidth, messStore),
            SizedBox(height: 8),
            _buildDaySelector(screenWidth, messStore),
            _buildMealSection(messStore),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, MessStore messStore) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: OColor.gray100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OText(
            text: 'Mess Menu',
            style: OTextStyle.headingMedium.copyWith(
              fontSize: screenWidth <= 390 ? 20 : 24,
              color: OColor.gray800,
            ),
          ),
          GestureDetector(
            onTap: () => _showHostelSheet(context, messStore),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Observer(
                    builder:
                        (context) => OText(
                          text: messStore.selectedMess.value!.displayString,
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.green600,
                            fontSize: screenWidth <= 390 ? 14 : 16,
                          ),
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(FluentIcons.chevron_down_24_regular, color: OColor.green600, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHostelSheet(BuildContext context, MessStore messStore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: OColor.white,
            border: Border.all(color: OColor.gray200),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: OSpacing.xs),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: OColor.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
                child: Row(
                  children: [
                    Icon(FluentIcons.building_home_24_regular, color: OColor.green600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select Hostel Mess',
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: OColor.gray100, shape: BoxShape.circle),
                        child: Icon(
                          FluentIcons.dismiss_24_regular,
                          size: 18,
                          color: OColor.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: OColor.gray200),
              // Hostel list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                  itemCount: hostels.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: OColor.gray100),
                  itemBuilder: (context, index) {
                    final hostel = hostels[index];
                    final isSelected = messStore.selectedMess.value!.displayString == hostel;
                    return InkWell(
                      onTap: () {
                        messStore.setMess(hostel.getMessFromDisplayString()!);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.m,
                          vertical: OSpacing.s,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                hostel,
                                style: OTextStyle.labelSmall.copyWith(
                                  color: isSelected ? OColor.green600 : OColor.gray800,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                FluentIcons.checkmark_24_filled,
                                color: OColor.green600,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDaySelector(double screenWidth, MessStore messStore) {
    final currentDayIndex = DateTime.now().weekday % 7;
    final reorderedDays = [...days.sublist(currentDayIndex), ...days.sublist(0, currentDayIndex)];

    return Observer(
      builder:
          (context) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  reorderedDays.map((day) {
                    final isSelected = messStore.selectedDay == day;
                    return Row(
                      children: [
                        SecondaryButton(
                          height: 40,
                          label: day,
                          onPressed: () => messStore.setDay(day),
                          enabled: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          labelStyle: OTextStyle.bodySmall.copyWith(
                            color: isSelected ? OColor.white : OColor.gray600,
                          ),
                          bgColor: isSelected ? OColor.green600 : OColor.gray100,
                          diabledBgColor: OColor.gray300,
                        ),
                        const SizedBox(width: 8),
                      ],
                    );
                  }).toList(),
            ),
          ),
    );
  }

  Widget _buildMealSection(MessStore messStore) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMealContainer('Breakfast', messStore),
            SizedBox(width: 8),
            _buildMealContainer('Lunch', messStore),
            SizedBox(width: 8),
            _buildMealContainer('Dinner', messStore),
          ],
        ),
      ),
    );
  }

  static const double _cardHeight = 280.0;
  static const double _cardWidth = 305.0;

  Widget _buildMealContainer(String mealName, MessStore messStore) {
    return Observer(
      builder: (context) {
        final key = ValueKey(
          "${messStore.selectedDay}-${messStore.selectedMess.value?.displayString}-$mealName",
        );

        return FutureBuilder<MealType>(
          key: key,
          future: messStore.getMealDataFor(mealName, messStore.selectedDay),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: OColor.gray200,
                highlightColor: OColor.gray100,
                child: Container(
                  width: _cardWidth,
                  height: _cardHeight,
                  decoration: BoxDecoration(
                    color: OColor.gray200,
                    borderRadius: BorderRadius.circular(OCornerRadius.l),
                  ),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.id.isEmpty) {
              return SizedBox(
                width: _cardWidth,
                height: _cardHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: OColor.white,
                    borderRadius: BorderRadius.circular(OCornerRadius.l),
                    border: Border.all(color: OColor.gray200, width: 1),
                  ),
                  child: Center(
                    child: OText(
                      text: "No data available\nfor $mealName",
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
                    ),
                  ),
                ),
              );
            }

            final mealData = snapshot.data!;
            return SizedBox(
              width: _cardWidth,
              height: _cardHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  border: Border.all(color: OColor.gray200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(OSpacing.s),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OCardHeader(heading: mealName, onClickArrow: false),
                          OLabelGroups(
                            labelItems: [
                              "${DateFormat.jm().format(mealData.startTiming)} - ${DateFormat.jm().format(mealData.endTiming)}",
                            ],
                            isSmall: false,
                          ),
                        ],
                      ),
                    ),
                    // Main Course — scrollable with fade hint
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.xs,
                          vertical: OSpacing.xxs,
                        ),
                        child: _buildScrollableBlock(
                          header: "Main Course",
                          items: [mealData.mealDescription],
                        ),
                      ),
                    ),
                    // Sides & Drinks
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: OSpacing.xs,
                              right: OSpacing.xs,
                              top: OSpacing.xxs,
                              bottom: OSpacing.s,
                            ),
                            child: OCardBlock(
                              header: "Sides",
                              blockItems: ['To Be Updated'],
                              color: OColor.gray100,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: OSpacing.xs,
                              right: OSpacing.xs,
                              top: OSpacing.xxs,
                              bottom: OSpacing.s,
                            ),
                            child: OCardBlock(
                              header: "Drinks",
                              blockItems: ['To Be Updated'],
                              color: OColor.gray100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScrollableBlock({required String header, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.all(OSpacing.xs),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(OCornerRadius.s)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OText(
            text: header.toUpperCase(),
            style: OTextStyle.labelXSmall.copyWith(color: OColor.gray600),
          ),
          const SizedBox(height: OSpacing.xs),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.white.withValues(alpha: 0)],
                  stops: const [0.0, 0.8, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Text(
                    items[index],
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray700),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
