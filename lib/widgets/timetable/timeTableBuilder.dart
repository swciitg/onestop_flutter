import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/timetable/dateSlider.dart';

class TimeTableSlider extends StatefulWidget {
  Map<int,List<List<String>>>data;
  int select=0;
  String sel;
  TimeTableSlider({Key? key,required this.data, required this.select, required this.sel}) : super(key: key);

  @override
  State<TimeTableSlider> createState() => _TimeTableSliderState();
}

class _TimeTableSliderState extends State<TimeTableSlider> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: widget.data[dates[widget.select].weekday]!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color:
                (widget.sel == widget.data[dates[widget.select].weekday]![index][0])
                    ? Color.fromRGBO(101, 174, 130, 0.16)
                    : Color.fromRGBO(120, 120, 120, 0.16),
                border:
                (widget.sel == widget.data[dates[widget.select].weekday]![index][0])
                    ? Border.all(color: Colors.blueAccent)
                    : Border.all(color: Colors.transparent),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Image.asset(
                                'assets/images/class.png'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.data[dates[widget.select].weekday]![index][0],
                            style: MyFonts.w300
                                .size(12)
                                .setColor(kWhite),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data[dates[widget.select].weekday]![
                                  index][1],
                                  style: MyFonts.w500
                                      .size(15)
                                      .setColor(kWhite),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            children: [
                              // Icon(
                              //   Icons.location_pin,
                              //   size: 13,
                              //   color: Color.fromRGBO(
                              //       212, 227, 255, 100),
                              // ),
                              Text(
                                widget.data[dates[widget.select].weekday]![index]
                                [2],
                                style: MyFonts.w300
                                    .size(13)
                                    .setColor(Color.fromRGBO(
                                    212, 227, 255, 100)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
