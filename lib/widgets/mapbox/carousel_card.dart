import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:provider/provider.dart';

class CarouselCard extends StatelessWidget {
  String name;
  int index;
  String time;
  CarouselCard({Key? key, required this.index, required this.time, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 3.0, right: 3),
      child: Observer(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(34, 36, 41, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                  color:
                      (context.read<MapBoxStore>().selectedCarouselIndex == index)
                          ? lBlue5
                          : kTileBackground),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      backgroundColor: lYellow2,
                      radius: 16,
                      child: Icon(
                        IconData(
                          0xe1d5,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: kBlueGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: MyFonts.w600.size(14).setColor(kWhite),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Next Bus at: ${context.read<MapBoxStore>().allLocationData[index]['time']}',
                          style: MyFonts.w500
                              .size(11)
                              .setColor(kGrey13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
