import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/travel/data.dart';
import 'bus_tile.dart';

class BusDetails extends StatefulWidget {
  late String day;
  BusDetails({Key? key, required this.day}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {

  bool isCity = false;
  bool isCampus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListTile(
            title: Text(
              'Campus -> City',
              style: MyFonts.w500.setColor(kWhite),
            ),
            subtitle: Text(
              'Starting from Biotech park',
              style: MyFonts.w500.setColor(Colors.grey),
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
              onPressed: () {setState(() {isCity = !isCity;});},
            ),
          ),
        ),
        isCity ?
        Column(
            children: Buses.map((e) {
              return BusTile(
                time: widget.day,
                isLeft: e['status'],
              );
            }).toList()) :
        Container(),
        Container(
          child: ListTile(
            title: Text(
              'City -> Campus',
              style: MyFonts.w500.setColor(kWhite),
            ),
            subtitle: Text(
              'Starting from City',
              style: MyFonts.w500.setColor(Colors.grey),
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_drop_down, color: kWhite,),
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
                time: widget.day,
                isLeft: e['status'],
              );
            }).toList())
            : Container(),
      ],
    );
  }
}
