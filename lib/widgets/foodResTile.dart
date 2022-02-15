import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';


class FoodResTile extends StatelessWidget {
  FoodResTile({
    Key? key,
    required this.Restaurant_name,
    required this.Cuisine_type,
    required this.Wating_time,
    required this.Closing_time,
    required this.distance,
  }) : super(key: key);

  final String Restaurant_name; 
  final String Cuisine_type;
  final int Wating_time;
  final String Closing_time;
  final int distance;

@override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 168,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        color: kBlueGrey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex : 1,
            child: new Image.asset('assets/images/res_foodimg.jpg'),
          ),
          SizedBox(
              width: 13,
          ),
          Expanded(
            flex : 2,
            child:Padding(padding: const EdgeInsets.all(5.0),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Expanded(
                  flex:1,
                  child: Text(
                    '$Restaurant_name',
                    style:MyFonts.bold.size(16).setColor(kWhite),
                  ),
                ),
                SizedBox(height: 5,),
                Expanded(
                  flex: 2,
                  child: Text(
                    Cuisine_type,
                    style: MyFonts.regular.size(14).setColor(kTabText),
                  )),
                  SizedBox(height: 8,),
                Expanded(
                  flex:2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                        'Waiting time: $Wating_time hrs',
                        style: MyFonts.medium.size(11).setColor(kRed),
                        )),
                        Expanded(
                          child: Text(
                            'Closes at $Closing_time',
                            style:MyFonts.medium.size(11).setColor(kTabText),
                            )),
                    ],
                  )),
                  SizedBox(height: 8,),
                  Expanded(
                    flex: 2,
                  
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Call_MapButton(Call_Map: 'Call',icon: Icons.call_end_outlined),
                        SizedBox(width: 5.0,),
                        Call_MapButton(Call_Map: 'Map',icon: Icons.location_on_outlined,),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Padding(
                            padding:  const EdgeInsets.only(top:10),
                            child: Text('$distance km',style: MyFonts.medium.size(11).setColor(kWhite),),
                          ))
                      ],
                    )),
              ],
            )
            ),
          ),
        ],
      ),
    );
  }
}

class Call_MapButton extends StatelessWidget {
  const Call_MapButton({
    Key? key,
    required this.Call_Map,
    required this.icon,
  }) : super(key: key);

  final String Call_Map;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: lGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 30,
                      color: kWhite,
                    ),
                    Padding(padding: const EdgeInsets.symmetric(
                      horizontal: 8
                    ),child: Text(
                      Call_Map,style: MyFonts.medium.setColor(kWhite),
                    )),
                  ],
                )
              ),
            )),
      ),
    );
  }
}