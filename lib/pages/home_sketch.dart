import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: MediaQuery.of(context).size.height,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox.fromSize(size: Size.fromHeight(20),),
                Expanded(flex:3,child: MapSample()),
                SizedBox(height: 15,),
                Expanded(flex:1,child: DateCourse()),
                SizedBox(height: 15,),
                Expanded(flex:1,child:QuickLinks()),
                SizedBox(height: 15,),
                Expanded(flex:1,child: Services()),
                SizedBox(height: 15,),
              ],
            ),
          ),
        ),
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
    return Row(
      children: [
        Expanded(
          flex:2,
          child: FittedBox(
            child: Column(
              children: [
                FittedBox(child: Text('MON',style:MyFonts.medium.size(25),)),
                FittedBox(child: Text('24',style: MyFonts.extraBold.size(50),))
              ],
            ),
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
    );
  }
}

class QuickLinks extends StatelessWidget {
  const QuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(25),
        color:Color.fromARGB(255, 43, 43, 46),
      ),
      child: Container(
        height: 160,
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            
            child: FittedBox(
              
              alignment: Alignment.centerLeft,
              
              child: Padding(
                
                padding: const EdgeInsets.all(10.0),
                child: Text('Quick Links',style: MyFonts.medium.size(30),),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FittedBox(
                  child: Container(
                    //margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark ),
                    padding: EdgeInsets.all(4.0),
                    child:Column( // Replace with a Row for horizontal icon + text
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        
                          Icon(Icons.computer_outlined,size: 30,color: lBlue,),
                          Text("IP Settings",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                        ],
                   ), 
                  ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark),
                    padding: EdgeInsets.all(4.0),
                    
                      child: Column( // Replace with a Row for horizontal icon + text
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Icon(Icons.article_outlined,size: 30,color: lBlue,),
                            Text("Papers",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                          ],
                   ),
                  ), 
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child:Container(
                    
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark ),
                    padding: EdgeInsets.all(4.0),
                    
                      child: Column( 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                            
                            Icon(Icons.medical_services_outlined,size: 30,color: lBlue),
                            Text("Medical Emergency",
                              style:MyFonts.medium.size(20).setColor(lBlue),
                                
                              textAlign: TextAlign.center)
                          ],
                   ),
                  ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark),
                    padding: EdgeInsets.all(4.0),
                    child:Column( 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                          Icon(Icons.contact_mail_outlined,size: 30,color: lBlue,),
                          Text("Contacts",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                        ],
                   ), 
                  ),
                ),
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

class Services extends StatelessWidget {
  const Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(25),
        color:Color.fromARGB(255, 43, 43, 46),
      ),
      child: Container(
        height: 160,
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            
            child: FittedBox(
              
              alignment: Alignment.centerLeft,
              
              child: Padding(
                
                padding: const EdgeInsets.all(10.0),
                child: Text('Services',style: MyFonts.medium.size(30),),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FittedBox(
                  child: Container(
                    //margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark ),
                    padding: EdgeInsets.all(4.0),
                    child:Column( // Replace with a Row for horizontal icon + text
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        
                          Icon(Icons.find_in_page_outlined,size: 30,color: lBlue,),
                          Text("Lost and Found",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                        ],
                   ), 
                  ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark),
                    padding: EdgeInsets.all(4.0),
                    
                      child: Column( // Replace with a Row for horizontal icon + text
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Icon(Icons.local_atm_outlined,size: 30,color: lBlue,),
                            Text("Rent and Sell",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                          ],
                   ),
                  ), 
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child:Container(
                    
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark ),
                    padding: EdgeInsets.all(4.0),
                    
                      child: Column( 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                            
                            Icon(Icons.shopping_cart_outlined,size: 30,color: lBlue),
                            Text("Shops",
                              style:MyFonts.medium.size(20).setColor(lBlue),
                                
                              textAlign: TextAlign.center)
                          ],
                   ),
                  ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ldark),
                    padding: EdgeInsets.all(4.0),
                    child:Column( 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                          Icon(Icons.language_outlined,size: 30,color: lBlue,),
                          Text("Intranet Websites",style:MyFonts.medium.size(20).setColor(lBlue),textAlign: TextAlign.center)
                        ],
                   ), 
                  ),
                ),
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
