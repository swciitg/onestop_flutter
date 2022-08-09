import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/mapbox_store.dart';
import 'package:onestop_dev/widgets/mapbox/mapBox.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/ferry_details.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  int selectBusesorStops = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      var map_store = context.read<MapBoxStore>();
      map_store.checkTravelPage(true);
      return SingleChildScrollView(
        child: Column(
          children: [
            MapBox(),
            SizedBox(
              height: 10,
            ),
            (map_store.indexBusesorFerry == 0)
                ? Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectBusesorStops = 0;
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: Container(
                                height: 32,
                                width: 83,
                                color: (selectBusesorStops == 0)
                                    ? lBlue2
                                    : kBlueGrey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*Icon(
                                  IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                                  color: (selectBusesorStops == 0)
                                      ? Color.fromRGBO(39, 49, 65, 1)
                                      : Colors.white,
                                ),*/
                                    Text(
                                      "Stops",
                                        style: (selectBusesorStops == 0) ? MyFonts.w500.setColor(kBlueGrey) : MyFonts.w500.setColor(kWhite)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectBusesorStops = 1;
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              child: Container(
                                height: 32,
                                width: 83,
                                color: (selectBusesorStops == 1)
                                    ? lBlue2
                                    : kBlueGrey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*Icon(
                                  IconData(0xe1d5, fontFamily: 'MaterialIcons'),
                                  color: (selectBusesorStops == 1)
                                      ? Color.fromRGBO(39, 49, 65, 1)
                                      : Colors.white,
                                ),*/
                                    Text(
                                      "Bus",
                                      style: (selectBusesorStops == 1) ? MyFonts.w500.setColor(kBlueGrey) : MyFonts.w500.setColor(kWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: kAppBarGrey),
                            child: DropdownButton<String>(
                              value: day,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: kWhite,
                                size: 13,
                              ),
                              elevation: 16,
                              style: MyFonts.w500.setColor(kWhite),
                              onChanged: (String? newValue) {
                                setState(() {
                                  day = newValue!;
                                });
                              },
                              underline: Container(),
                              items: <String>[
                                'Weekdays',
                                'Weekends'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: MyFonts.w500,),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                      (selectBusesorStops == 0)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: context
                                  .read<MapBoxStore>()
                                  .bus_carousel_data
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        map_store.selectedCarousel(index);
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(34, 36, 41, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color: (map_store
                                                        .selectedCarouselIndex ==
                                                    index)
                                                ? Color.fromRGBO(
                                                    101, 144, 210, 1)
                                                : Color.fromRGBO(
                                                    34, 36, 41, 1)),
                                      ),
                                      child: ListTile(
                                        textColor: kWhite,
                                        leading: const CircleAvatar(
                                          backgroundColor:
                                              Color.fromRGBO(255, 227, 125, 1),
                                          radius: 26,
                                          child: Icon(
                                            IconData(
                                              0xe1d5,
                                              fontFamily: 'MaterialIcons',
                                            ),
                                            color: kBlueGrey,
                                          ),
                                        ),
                                        title: Text(
                                          map_store.bus_carousel_data[index]
                                              ['name'],
                                          style: MyFonts.w500.setColor(kWhite),
                                        ),
                                        subtitle: Text(
                                          map_store.bus_carousel_data[index]
                                              ['distance'].toString()+" km",
                                          style: MyFonts.w500.setColor(Color.fromRGBO(119, 126, 141, 1))
                                        ),
                                        trailing: (map_store.bus_carousel_data[
                                                    index]['status'] ==
                                                'left')
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Left',
                                                    style: MyFonts.w500.setColor(Color.fromRGBO(135, 145, 165, 1)),
                                                  ),
                                                  Text(
                                                    map_store.bus_carousel_data[
                                                        index]['time'],
                                                    style: MyFonts.w500.setColor(Color.fromRGBO(195, 198, 207, 1)),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                map_store.bus_carousel_data[
                                                    index]['time'],
                                                style: MyFonts.w500.setColor(lBlue2),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : BusDetails(day: day),
                    ],
                  )
                : FerryDetails(),
          ],
        ),
      );
    });
  }
}

// Column(
// children: map_store.bus_carousel_data.map((item) {

// }).toList(),
// ) :
