import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/hostels.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/mess_store.dart';
import 'package:onestop_dev/widgets/food/mess/mess_meal.dart';
import 'package:provider/provider.dart';

import '../../../models/profile/profile_model.dart';

class MessMenu extends StatelessWidget {
  MessMenu({
    Key? key,
  }) : super(key: key);

  final List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final List<String> hostels = khostels.sublist(0, khostels.length - 1);
  // last item is Married Scholars

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Provider(
      create: (_) => MessStore(),
      builder: (context, _) {
        var messStore = context.read<MessStore>();
        var userHostel = ProfileModel.fromJson(LoginStore.userData).hostel;
        messStore.setHostel(userHostel ?? hostels.first);
        if (userHostel == "Married Scholars") {
          userHostel = "Kameng";
          messStore.setHostel(userHostel);
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
                  if (!messStore.hostelLoaded) {
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
                                  : "${DateFormat.jm().format(messStore.mealData.startTiming)} - ${DateFormat.jm().format(messStore.mealData.endTiming)}", // id empty means not updated by HMC
                              style: MyFonts.w500.size(12).setColor(kGrey12),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: SingleChildScrollView(
                                  child: Text(
                                      messStore.mealData.mealDescription,
                                      style: MyFonts.w400
                                          .size(14)
                                          .setColor(kWhite)))),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PopupMenuButton<String>(
                                  initialValue: userHostel,
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
                                                style: MyFonts.w500
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
                                            style: MyFonts.w500
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
                                              messStore.setHostel(value);
                                            },
                                            value: value,
                                            child: Text(
                                              value,
                                              style:
                                                  MyFonts.w500.setColor(kWhite),
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
                                        Text(messStore.selectedHostel.value!,
                                            overflow: TextOverflow.fade,
                                            style: MyFonts.w500
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
