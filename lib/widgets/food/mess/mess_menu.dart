import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
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
      Mess.values
          .displayStrings()
          .where((e) => e != Mess.none.displayString)
          .toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Provider(
      create: (_) => MessStore(),
      builder: (context, _) {
        final messStore = context.read<MessStore>();
        messStore.setMess(
          OneStopUser.fromJson(
                LoginStore.userData,
              ).subscribedMess?.getMessFromDatabaseString() ??
              messStore.defaultUserMess,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(screenWidth, messStore),
            SizedBox(height: 8),
            _buildDaySelector(screenWidth, messStore),
            _buildMealSection(messStore),
          ],
        );
      },
    );
  }

  Widget _buildHeader(double screenWidth, MessStore messStore) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: OColor.gray100,
      ),
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
          PopupMenuButton<String>(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 320),
            color: OColor.white,
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FluentIcons.building_home_24_regular,
                                color: OColor.green600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              OText(
                                text: "Hostel Mess",
                                style: OTextStyle.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: OColor.black,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: OColor.gray100,
                              ),
                              child: Icon(
                                Icons.close,
                                color: OColor.gray600,
                                size: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.only(left: 48.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...hostels.map(
                    (value) => PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          messStore.setMess(value.getMessFromDisplayString()!);
                          Navigator.pop(context);
                        },
                        child: _buildHostelOption(value, messStore),
                      ),
                    ),
                  ),
                ],
            offset: const Offset(0, 40),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
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
                  Icon(
                    FluentIcons.chevron_down_24_regular,
                    color: OColor.green600,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostelOption(String value, MessStore messStore) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: OColor.gray200, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OText(
            text: value,
            style: OTextStyle.bodySmall.copyWith(
              color:
                  messStore.selectedMess.value!.displayString == value
                      ? OColor.green500
                      : OColor.black,
            ),
          ),
          Observer(
            builder:
                (context) => RadioButton(
                  value: messStore.selectedMess.value!.displayString == value,
                  onChanged: (isSelected) {
                    if (isSelected) {
                      messStore.setMess(value.getMessFromDisplayString()!);
                      Navigator.pop(context);
                    }
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(double screenWidth, MessStore messStore) {
    final currentDayIndex = DateTime.now().weekday % 7;
    final reorderedDays = [
      ...days.sublist(currentDayIndex),
      ...days.sublist(0, currentDayIndex),
    ];

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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          labelStyle: OTextStyle.bodySmall.copyWith(
                            color: isSelected ? OColor.white : OColor.gray600,
                          ),
                          bgColor:
                              isSelected ? OColor.green600 : OColor.gray200,
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
    return Container(
      color: Colors.transparent,
      height: 290,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19),
          child: Row(
            children: [
              _buildMealContainer('Breakfast', messStore),
              SizedBox(width: 8),
              _buildMealContainer('Lunch', messStore),
              SizedBox(width: 8),
              _buildMealContainer('Dinner', messStore),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealContainer(String mealName, MessStore messStore) {
    return Observer(
      builder: (context) {
        // Create a unique key based on selectedDay and selectedMess
        final key = ValueKey(
          "${messStore.selectedDay}-${messStore.selectedMess.value?.displayString}-$mealName",
        );

        return FutureBuilder<MealType>(
          key: key, // Use the key to force rebuild
          future: messStore.getMealDataFor(mealName, messStore.selectedDay),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: kBlueGrey,
                highlightColor: kBlueGrey,
                child: Container(
                  width: 305,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.id.isEmpty) {
              return OText(
                text: "No data available for $mealName",
                style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
              );
            }

            final mealData = snapshot.data!;
            return SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 305,
                  height: 310,
                  child: OMessMenuCard(
                    heading: mealName,
                    subLabelText: [
                      "${DateFormat.jm().format(mealData.startTiming)} - ${DateFormat.jm().format(mealData.endTiming)}",
                    ],
                    blockHeading1: "Main Course",
                    blockHeading2: "Sides",
                    blockHeading3: "Drinks",
                    blockItems1: [mealData.mealDescription],
                    blockItems2: ['To Be Updated'],
                    blockItems3: ['To Be Updated'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
