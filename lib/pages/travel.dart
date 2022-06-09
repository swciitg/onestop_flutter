import 'package:flutter/material.dart';
import 'package:onestop_dev/globals.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/widgets/mapBox.dart';
import 'package:onestop_dev/widgets/travel/bus_tile.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  int selectBusesorStops = 0;
  bool isCity = false;
  bool isCampus = false;
  double lat = 0;
  double long = 0;
  int selectedIndex = 0;

  void rebuildParent(int newSelectedIndex) {
    print('Reloaded');
    setState(() {
      selectedIndex = newSelectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MapBox(
            selectedIndex: selectedIndex,
            lat: (lat != 0) ? lat : null,
            long: (long != 0) ? long : null,
            rebuildParent: rebuildParent,
            istravel: false,
          ),
          SizedBox(height: 10,),
          (selectedIndex == 0)
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
                      borderRadius: BorderRadius.all(Radius.circular(40),),
                      child: Container(
                        height: 32, width: 83,
                        color: (selectBusesorStops == 0)
                            ? lBlue2 : kBlueGrey,
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
                              style: TextStyle(
                                color: (selectBusesorStops == 0)
                                    ? kBlueGrey : kWhite,
                              ),
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
                      borderRadius: BorderRadius.all(Radius.circular(40),),
                      child: Container(
                        height: 32, width: 83,
                        color: (selectBusesorStops == 1)
                            ? lBlue2 : kBlueGrey,
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
                              style: TextStyle(
                                color: (selectBusesorStops == 1)
                                    ? kBlueGrey : kWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              (selectBusesorStops == 0)
                  ? Column(
                children: BusStops.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = item['ind'];
                          lat = item['lat'];
                          long = item['long'];
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(34, 36, 41, 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              color: (isSelected == item['ind'])
                                  ? Color.fromRGBO(101, 144, 210, 1)
                                  : Color.fromRGBO(34, 36, 41, 1)),
                        ),
                        child: ListTile(
                          textColor: kWhite,
                          leading: const CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(255, 227, 125, 1),
                            radius: 26,
                            child: Icon(
                              IconData(0xe1d5, fontFamily: 'MaterialIcons',),
                              color: kBlueGrey,
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(color: kWhite),
                          ),
                          subtitle: Text(
                            item['distance'],
                            style: const TextStyle(color: Color.fromRGBO(119, 126, 141, 1)),
                          ),
                          trailing: (item['status'] == 'left')
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Left',
                                style: TextStyle(color: Color.fromRGBO(135, 145, 165, 1)),
                              ),
                              Text(
                                item['time'],
                                style: const TextStyle(color: Color.fromRGBO(195, 198, 207, 1)),
                              ),
                            ],
                          )
                              : Text(
                            item['time'],
                            style: TextStyle(color: lBlue2),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ) : SizedBox(),
              (selectBusesorStops == 1)
                  ? Column(
                children: [
                  Container(
                    child: ListTile(
                      title: Text(
                        'Campus -> City',
                        style: TextStyle(color: kWhite),
                      ),
                      subtitle: Text(
                        'Starting from Biotech park',
                        style: TextStyle(color: kGrey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isCity = !isCity;
                          });
                        },
                      ),
                    ),
                  ),
                  isCity
                      ? Column(
                      children: Buses.map((e) {
                        return BusTile(
                          time: e['time'],
                          isLeft: e['status'],
                        );
                      }).toList())
                      : Container(),
                  Container(
                    child: ListTile(
                      title: Text(
                        'City -> Campus',
                        style: TextStyle(color: kWhite),
                      ),
                      subtitle: Text(
                        'Starting from City',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: kWhite,
                        ),
                        onPressed: () {
                          setState(() {
                            isCampus = !isCampus;
                          });
                        },
                      ),
                    ),
                  ),
                  isCampus
                      ? Column(
                      children: Buses.map((e) {
                        return BusTile(
                          time: e['time'],
                          isLeft: e['status'],
                        );
                      }).toList())
                      : Container(),
                ],
              )
                  : SizedBox(),
            ],
          )
              : Column(
              children: Buses.map((e) {
                return BusTile(
                  time: e['time'],
                  isLeft: e['status'],
                );
              }).toList())
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> BusStops = [
  {
    'name': 'Kameng Bus Stop',
    'lat': 30.000000,
    'long': 60.000000,
    'status': 'left',
    'time': '1:45 PM',
    'distance': '1.4km',
    'ind': 0,
  },
  {
    'name': 'Manas Bus Stop',
    'lat': 40.000000,
    'long': 50.000000,
    'status': 'left',
    'time': '1:45 PM',
    'distance': '1.4km',
    'ind': 1,
  }
];

List<Map<String, dynamic>> Buses = [
  {
    'status': false,
    'time': '1:45 PM',
  }
];