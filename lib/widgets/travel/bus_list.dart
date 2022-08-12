import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/travel_drop_down.dart';
import 'package:provider/provider.dart';

class BusList extends StatelessWidget {
  const BusList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(context.read<TravelStore>());
    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                      context.read<TravelStore>().selectStopButton();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: Container(
                      height: 32,
                      width: 83,
                      color: (!context.read<TravelStore>().isBusSelected)
                          ? lBlue2
                          : kBlueGrey,
                      child: Center(
                        child: Text("Stops",
                            style: (!context.read<TravelStore>().isBusSelected)
                                ? MyFonts.w500.setColor(kBlueGrey)
                                : MyFonts.w500.setColor(kWhite)),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<TravelStore>().selectBusButton();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    child: Container(
                      height: 32,
                      width: 83,
                      color: (context.read<TravelStore>().isBusSelected)
                          ? lBlue2
                          : kBlueGrey,
                      child: Center(
                        child: Text(
                          "Bus",
                          style: (context.read<TravelStore>().isBusSelected)
                              ? MyFonts.w500.setColor(kBlueGrey)
                              : MyFonts.w500.setColor(kWhite),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                TravelDropDown()
              ],
            ),
            context.read<TravelStore>().busPage
          ],
        );
      }
    );
  }
}
