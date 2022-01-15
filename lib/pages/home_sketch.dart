import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/sizeConfig.dart';
import 'package:onestop_dev/widgets/appbar.dart';

class HomePageSketch extends StatelessWidget {
  static String id = "/home2";
  const HomePageSketch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox.fromSize(size: Size.fromHeight(20),),
          MapSample(),
          DateCourse(),
          QuickLinks(),
        ],
      )
    );
  }
}

class MapSample extends StatelessWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/sample_map.png');
  }
}

class DateCourse extends StatelessWidget {
  const DateCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex:2,
            child: Column(
              children: [
                Text('MON',style:TextStyle(fontSize: 25)),
                Text('24',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50),)
              ],
            ),
          ),
          Expanded(
          flex:5,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color.fromRGBO(101, 174, 130, 0.16)
      ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            flex:1,
            child: Container(
              height: 100,
              child: Icon(Icons.keyboard_arrow_down_sharp),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromRGBO(101, 174, 130, 0.16)
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QuickLinks extends StatelessWidget {
  const QuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromRGBO(240, 243, 248, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Quick Links',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 75,
                    color: Color.fromRGBO(224, 235, 255, 1),
                    child: Icon(Icons.computer_outlined,size: 30,),
                  ),
                  Container(
                    width: 75,
                    color: Color.fromRGBO(224, 235, 255, 1),
                    child: Icon(Icons.computer_outlined,size: 30,),
                  ),
                  Container(
                    width: 75,
                    color: Color.fromRGBO(224, 235, 255, 1),
                    child: Icon(Icons.computer_outlined,size: 30,),
                  ),
                  Container(
                    width: 75,
                    color: Color.fromRGBO(224, 235, 255, 1),
                    child: Icon(Icons.computer_outlined,size: 30,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
