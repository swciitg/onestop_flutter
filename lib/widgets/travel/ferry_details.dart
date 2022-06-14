import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/travel/bus_tile.dart';
import 'drop_down.dart';
import 'package:onestop_dev/globals/travel_details.dart';
import 'package:onestop_dev/functions/travel/has_left.dart';

String day = 'Weekdays';
String from = 'Campus to City';

class FerryDetails extends StatefulWidget {
  const FerryDetails({Key? key}) : super(key: key);

  @override
  State<FerryDetails> createState() => _FerryDetailsState();
}

class _FerryDetailsState extends State<FerryDetails> {
  int index = 0;

  int _selectdata()
  {
    if(from == 'Campus to City')
    {if(day == 'Weekends') {return 0;} else {return 1;}}
    else {if(day == 'Weekends') {return 2;} else {return 3;}}
  }

  refresh() {
    setState(() {});
    hasLeft('1:30 PM');
    index = _selectdata();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropButton(day: 0, data: ['Campus to City', 'City to Campus'], f:refresh),
              DropButton(day: 1, data: ['Weekdays', 'Weekends'], f: refresh,),
            ],
          ),
          Column(
            children: FERRYTIME[index].map((e) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: BusTile(
                  time: e,
                  isLeft: hasLeft(e.toString()),
                ),
              );
            }).toList(),
          )
        ]
    );
  }
}



