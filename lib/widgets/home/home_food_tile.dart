import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/food/mess_menu_model.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/services/home_food_widget_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/home/home_widget.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

class HomeFoodTile extends StatelessWidget {
  final VoidCallback moveToFoodMenu;
  const HomeFoodTile({super.key, required this.moveToFoodMenu});

  String _currentMealName() {
    final now = DateTime.now().toLocal();
    if (now.hour < 10) return 'Breakfast';
    if (now.hour < 14 || (now.hour == 14 && now.minute <= 30)) return 'Lunch';
    return 'Dinner';
  }

  String _currentDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  Future<MealType> _fetchMealData() async {
    final mess =
        OneStopUser.fromJson(LoginStore.userData).subscribedMess?.getMessFromDatabaseString() ??
        Mess.values.first;
    final meal = await DataService.getMealData(
      mess: mess,
      day: _currentDay(),
      mealType: _currentMealName(),
    );

    // Sync to home screen widget with already-fetched data (no re-fetch)
    final mealName = _currentMealName();
    final endTime = DateFormat('h:mm a').format(meal.endTiming);
    final items = meal.mealDescription
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim().replaceFirst(RegExp(r'^\d+\.\s*'), ''))
        .where((e) => e.isNotEmpty)
        .join('\n');
    HomeFoodWidgetService.syncMealData(mealName: mealName, endTime: endTime, items: items);

    return meal;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: moveToFoodMenu,
      child: HomeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/images/food.svg", width: 32, height: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: OText(
                    text: 'Food',
                    style: OTextStyle.headingSmall.copyWith(
                      color: OColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(FluentIcons.chevron_right_24_regular, color: OColor.gray400, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ClipRect(
                child: FutureBuilder<MealType>(
                  future: _fetchMealData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.id.isEmpty) {
                      return OText(
                        text: _currentMealName().toUpperCase(),
                        style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                      );
                    }
                    final meal = snapshot.data!;
                    final endTime = DateFormat('h:mm a').format(meal.endTiming);
                    final description = meal.mealDescription
                        .split(RegExp(r'[;]'))
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .join('\n');
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OText(
                                text: '${_currentMealName().toUpperCase()} \u2022 ENDS $endTime',
                                style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: OText(
                                  text: description,
                                  style: OTextStyle.bodyXSmall.copyWith(
                                    color: OColor.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
