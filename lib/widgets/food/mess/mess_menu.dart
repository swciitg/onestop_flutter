import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/food/mess/mess_meal.dart';
import 'package:webfeed/domain/media/media.dart';

class MessMenu extends StatelessWidget {
  MessMenu({
    Key? key,
  }) : super(key: key);

  StreamController mealController = StreamController();
  StreamController<String> dayController = StreamController();
  StreamController<String> hostelController = StreamController();

  List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> hostels = [
    "Brahmaputra",
    "Lohit",
    "Kameng",
    "Umiam",
    "Barak",
    "Manas",
    "Dihing",
    "Disang"
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: 171,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: kBlueGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            StreamBuilder(
                stream: mealController.stream,
                builder: (context, mealSnapshot) {
                  return Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  if (mealSnapshot.hasData == true &&
                                      mealSnapshot.data == "Breakfast") {
                                    return;
                                  }
                                  mealController.sink.add("Breakfast");
                                },
                                child: MessMeal(
                                  mealName: "Breakfast",
                                  selected: (mealSnapshot.hasData == true &&
                                          mealSnapshot.data == "Breakfast")
                                      ? true
                                      : false,
                                )),
                          ),
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  if (mealSnapshot.hasData == true &&
                                      mealSnapshot.data == "Lunch") {
                                    return;
                                  }
                                  mealController.sink.add("Lunch");
                                },
                                child: MessMeal(
                                  mealName: "Lunch",
                                  selected: (mealSnapshot.hasData == true &&
                                          mealSnapshot.data == "Lunch")
                                      ? true
                                      : false,
                                )),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (mealSnapshot.hasData == true &&
                                    mealSnapshot.data == "Dinner") {
                                  return;
                                }
                                mealController.sink.add("Dinner");
                              },
                              child: MessMeal(
                                mealName: "Dinner",
                                selected: (mealSnapshot.hasData == true &&
                                        mealSnapshot.data == "Dinner")
                                    ? true
                                    : false,
                              ),
                            ),
                          ),
                        ],
                      ));
                }),
            SizedBox(
              width: 16,
            ),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "8:00 pm - 10:15 pm",
                        style: MyFonts.w500.size(12).setColor(kGrey12),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                            child: Text(
                                "Dal Makhani, Rasam, Green Peas, Cauliflower, Rice, Roti, Salad",
                                style: MyFonts.w400
                                    .size(14)
                                    .setColor(kWhite)))),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) => print(value),
                            itemBuilder: (context) {
                              return days
                                  .map(
                                    (value) => PopupMenuItem(
                                      onTap: () {
                                        dayController.sink.add(value);
                                      },
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList();
                            },
                            offset: Offset(1, 40),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                  color: kGrey2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StreamBuilder<String>(
                                      stream: dayController.stream,
                                      builder: (context, daySnapshot) {
                                        return Text(
                                            daySnapshot.hasData == true
                                                ? daySnapshot.data!
                                                : "Mon",
                                            style: MyFonts.w500
                                                .setColor(lBlue)
                                                .size(screenWidth <= 380
                                                    ? 10
                                                    : 13));
                                      }),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: lBlue,
                                    size: screenWidth <= 380 ? 15 : 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          PopupMenuButton<String>(
                            onSelected: (value) => print(value),
                            itemBuilder: (context) {
                              return hostels
                                  .map(
                                    (value) => PopupMenuItem(
                                      onTap: () {
                                        hostelController.sink.add(value);
                                      },
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                            offset: Offset(1, 40),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: lBlue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StreamBuilder<String>(
                                      stream: hostelController.stream,
                                      builder: (context, hostelSnapshot) {
                                        return Text(
                                            hostelSnapshot.hasData == true
                                                ? hostelSnapshot.data!
                                                : "Brahmaputra",
                                            style: MyFonts.w500
                                                .setColor(lBlue)
                                                .size(screenWidth <= 380
                                                    ? 10
                                                    : 13));
                                      }),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: lBlue,
                                    size: screenWidth <= 380 ? 15 : 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    )
                  ],
                ))
          ]),
        ));
  }
}
