import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/tracking_dailog.dart';
import 'package:onestop_dev/widgets/travel/travel_drop_down.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class StopsBusDetails extends StatefulWidget {
  const StopsBusDetails({Key? key}) : super(key: key);

  @override
  State<StopsBusDetails> createState() => _StopsBusDetailsState();
}

class _StopsBusDetailsState extends State<StopsBusDetails> {
  @override
  void initState() {
    super.initState();
    if (DateTime.now().weekday == DateTime.sunday ||
        DateTime.now().weekday == DateTime.saturday) {
      context.read<TravelStore>().setBusDayString("Weekends");
    }
  }

  @override
  Widget build(BuildContext context) {
    var travelStore = context.read<TravelStore>();
    return Observer(builder: (context) {
      return Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => const TrackingDailog());
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  child: Container(
                    height: 32,
                    width: 83,
                    color: lBlue2,
                    child: Center(
                      child: Text(" Track Bus ",
                          style: MyFonts.w500.setColor(kBlueGrey)),
                    ),
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     showDialog(
              //         context: context, builder: (_) => const TrackingDailog());
              //   },
              //   child: Text(
              //     "Track Bus",
              //     style: MyFonts.w500.setColor(kWhite),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     travelStore.selectStopButton();
              //   },
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(40),
              //     ),
              //     child: Container(
              //       height: 32,
              //       width: 83,
              //       color: (!travelStore.isBusSelected) ? lBlue2 : kGrey2,
              //       child: Center(
              //         child: Text("Stops",
              //             style: (!travelStore.isBusSelected)
              //                 ? MyFonts.w500.setColor(kBlueGrey)
              //                 : MyFonts.w500.setColor(kWhite)),
              //       ),
              //     ),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     travelStore.selectBusButton();
              //   },
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(40),
              //     ),
              //     child: Container(
              //       height: 32,
              //       width: 83,
              //       color: (travelStore.isBusSelected) ? lBlue2 : kGrey2,
              //       child: Center(
              //         child: Text(
              //           "Bus",
              //           style: (travelStore.isBusSelected)
              //               ? MyFonts.w500.setColor(kBlueGrey)
              //               : MyFonts.w500.setColor(kWhite),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Container(),
              ),
              TravelDropDown(
                value: travelStore.busDayType,
                onChange: travelStore.setBusDayString,
                items: const ['Weekdays', 'Weekends'],
              )
            ],
          ),
          BusDetails(index: travelStore.busDayTypeIndex)
        ],
      );
    });
  }
}
