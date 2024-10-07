import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mess_store.dart';
import 'package:onestop_dev/widgets/food/mess/mess_meal.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class MessMenu extends StatelessWidget {
  MessMenu({super.key});

  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final List<String> hostels = Mess.values
      .displayStrings()
      .where((element) => element != Mess.none.displayString)
      .toList();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Provider(
      create: (_) => MessStore(),
      builder: (context, _) {
        final messStore = context.read<MessStore>();
        Mess? userMess = OneStopUser.fromJson(LoginStore.userData)
            .subscribedMess
            ?.getMessFromDatabaseString();

        if (userMess == Mess.none) {
          userMess = messStore.defaultUserMess;
          messStore.setMess(userMess);
        } else {
          messStore.setMess(userMess ?? messStore.defaultUserMess);
        }

        return Container(
            height: 171,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: kBlueGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MessMeal(mealName: "Breakfast"),
                        MessMeal(mealName: "Lunch"),
                        MessMeal(mealName: "Dinner")
                      ],
                    )),
                const SizedBox(
                  width: 16,
                ),
                Observer(builder: (context) {
                  if (!messStore.messLoaded) {
                    return Expanded(
                      flex: 2,
                      child: Container(),
                    );
                  }
                  return Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              messStore.mealData.id.isEmpty
                                  ? "Not Specified"
                                  : "${DateFormat.jm().format(messStore.mealData.startTiming)} - ${DateFormat.jm().format(messStore.mealData.endTiming)}",
                              // id empty means not updated by HMC
                              style:
                                  OnestopFonts.w500.size(12).setColor(kGrey12),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: SingleChildScrollView(
                                  child: Text(
                                      messStore.mealData.mealDescription,
                                      style: OnestopFonts.w400
                                          .size(14)
                                          .setColor(kWhite)))),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PopupMenuButton<String>(
                                  initialValue: messStore.selectedDay,
                                  color: kBlueGrey,
                                  itemBuilder: (context) {
                                    return days
                                        .map(
                                          (value) => PopupMenuItem(
                                            onTap: () {
                                              messStore.setDay(value);
                                            },
                                            value: value,
                                            child: Text(value.substring(0, 3),
                                                style: OnestopFonts.w500
                                                    .setColor(kWhite)),
                                          ),
                                        )
                                        .toList();
                                  },
                                  offset: const Offset(1, 40),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 12.0),
                                    decoration: const BoxDecoration(
                                        color: kGrey2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            messStore.selectedDay
                                                .substring(0, 3),
                                            style: OnestopFonts.w500
                                                .setColor(lBlue)
                                                .size(screenWidth <= 390
                                                    ? 10
                                                    : 13)),
                                        Icon(
                                          FluentIcons.chevron_down_24_regular,
                                          color: lBlue,
                                          size: screenWidth <= 390 ? 15 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  constraints:
                                      const BoxConstraints(maxHeight: 320),
                                  color: kBlueGrey,
                                  itemBuilder: (context) {
                                    return hostels
                                        .map(
                                          (value) => PopupMenuItem(
                                            onTap: () {
                                              messStore.setMess(value
                                                  .getMessFromDisplayString()!);
                                            },
                                            value: value,
                                            child: Text(
                                              value,
                                              style: OnestopFonts.w500
                                                  .setColor(kWhite),
                                            ),
                                          ),
                                        )
                                        .toList();
                                  },
                                  offset: const Offset(1, 40),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: lBlue),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            messStore.selectedMess.value!
                                                .displayString,
                                            overflow: TextOverflow.fade,
                                            style: OnestopFonts.w500
                                                .setColor(lBlue)
                                                .size(screenWidth <= 390
                                                    ? 10
                                                    : 13)),
                                        Icon(
                                          FluentIcons.chevron_down_24_regular,
                                          color: lBlue,
                                          size: screenWidth <= 390 ? 15 : 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ));
                })
              ]),
            ));
      },
    );
  }
}
