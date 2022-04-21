import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/IPsettings.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

bool fg=true;

List<String> textdata = [
  'Open Start-> Control Panel -> Network and Internet-> Network and Sharing Center ',
  "Click on 'Manage wireless networks'",
  'Right click on \'Local area connection\' and then click on properties',
  'Uncheck \'Internet Protocol Version 6 (TCP/IPv6)\' and double click \'Internet Protocol Version 4 (TCP/IPv4)\'',
  'Select \'Use the following IP address\' and \'Use the following DNS server addresses\' Modify the DNS address as given below\n\n\nprimary DNS: 172.171.1.1\nsecondary DNS: 172.17.1.2',
  'Enter the following details to get your IP address',
  '',
  "Make sure the connection is no-proxy/direct connection. Open any website in your browser. It will show a captive portal asking your IITG login credentials.Login to the portal and start accessing internet using the same.If you have a problem while redirecting to login page, then use this link given below in your pc browser https://agnigarh.iitg.ac.in:1442/login?"];
List<String> imagedata = ['', ''];

class RouterPage extends StatefulWidget {
  static String id = "/ip";

  const RouterPage({Key? key}) : super(key: key);

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {

  int page = 1;
  CarouselController _buttonCarouselController = CarouselController();
  TextEditingController roomController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  hostelDetails hostel=hostelDetails("nothing", "--", "--=-=-===","something") ;
  String dropdownValue="Select Hostel";
  final _keyform= GlobalKey<FormState>();
  List <String> spinnerItems = [
    'Select Hostel',
    'Barak',
    'Umiam',
    'Brahmaputra',
    'Manas',
    'Dihing',
    'Dibang',
    'Married Scholars',
    'Siang',
    'Dhansiri',
    'Subhansiri',
    'Kapili',
    'Kameng'
  ] ;

  @override
  void initState() {
    super.initState();
    setState(() {
      page = 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    double HEIGHT = MediaQuery.of(context).size.height;
    double WIDTH  = MediaQuery.of(context).size.width;
    print(HEIGHT);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: HEIGHT*0.064,
        backgroundColor: Color.fromRGBO(39, 49, 65, 1),
        leading: Container(),
        leadingWidth: 0,
        title: Text('Internet Settings', style: TextStyle(fontFamily: 'Montserrat'),),
        actions: [
          IconButton(onPressed: (){ Navigator.of(context).pop();}, icon: Icon(IconData(0xe16a, fontFamily: 'MaterialIcons')))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: HEIGHT*0.188198,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Text(
                  'You might need to change some of your laptop settings before you could start using the internet in your room. Go through the following steps after connecting your laptop to the LAN port. ',
                  style: TextStyle(color: Color.fromRGBO(135, 145, 165, 1), fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Montserrat'),
                ),
              ),
            ),
            Container(
              height: HEIGHT*0.63,
              width: WIDTH*0.93,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(39, 49, 65, 1),
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),

              child: Padding(
                padding: EdgeInsets.fromLTRB(16, HEIGHT*0.03073, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: [1,2,3,4,5,6,7,8].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: HEIGHT*0.0256,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Step $i of 8', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17, fontFamily: 'Montserrat'),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: HEIGHT*0.0064,
                                ),
                                Text(textdata[i-1], style: TextStyle(color: Color.fromRGBO(224, 226, 235, 1), fontWeight: FontWeight.w400, fontSize: HEIGHT*0.02048417, fontFamily: 'Montserrat'),),
                                SizedBox(
                                  height: HEIGHT*0.0064,
                                ),

                                (i==6)?Form(
                                  key: _keyform,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: HEIGHT*0.0128,
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(canvasColor: Color.fromRGBO(39, 49, 65, 1)),
                                        child: SizedBox(
                                          height: HEIGHT*0.0768156,
                                          child: DropdownButtonFormField<String>(
                                            value: dropdownValue,
                                            icon: Icon(Icons.arrow_drop_down),
                                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                            onChanged: (data) {
                                              setState(() {
                                                dropdownValue = data!;
                                                hostel.hostelName=dropdownValue;
                                              });
                                              print(hostel);
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(110, 119, 138, 1),
                                                    width: 0.8
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(110, 119, 138, 1),
                                                  width: 1.0,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: BorderSide(color: Color.fromRGBO(110, 119, 138, 1), width: 5.0),
                                              ),

                                            ),


                                            items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value, style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 15)),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0128,
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0768156,
                                        child: TextFormField(
                                            style: TextStyle(color: Colors.white),
                                            // Tell your textfield which controller it owns
                                            validator: (value){
                                              if(value==null || value.isEmpty){return "Remember your room number correctly";}
                                              return null;
                                            },
                                            controller: roomController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            onChanged: (v){ roomController.text = v;hostel.roomNo=v;roomController.selection = TextSelection.fromPosition(TextPosition(offset: roomController.text.length));},
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(110, 119, 138, 1),
                                                    width: 1.0
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(110, 119, 138, 1),
                                                  width: 1.0,
                                                ),
                                              ),
                                              labelStyle: TextStyle(color: Color.fromRGBO(110, 119, 138, 1), fontWeight: FontWeight.w600),
                                              labelText: 'Room Number',
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0128,
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0768156,
                                        child: TextFormField(
                                            style: TextStyle(color: Colors.white),
                                            validator: (value){
                                              if(value==null || value.isEmpty){return "remember your block number correctly";}
                                              return null;
                                            },
                                            controller: blockController,
                                            keyboardType: TextInputType.text,
                                            onChanged: (v){ blockController.text = v;hostel.block=v;blockController.selection = TextSelection.fromPosition(TextPosition(offset: blockController.text.length));},
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(color: Color.fromRGBO(110, 119, 138, 1), fontWeight: FontWeight.w600),
                                              labelText: 'Block',
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(110, 119, 138, 1),
                                                    width: 1.0
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(110, 119, 138, 1),
                                                  width: 1.0,
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0128,
                                      ),
                                      SizedBox(
                                        height: HEIGHT*0.0768156,
                                        child: TextFormField(
                                            style: TextStyle(color: Colors.white),
                                            validator: (value){
                                              if(value==null || value.isEmpty){return "remember your floor number correctly";}
                                              return null;
                                            },
                                            controller: floorController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            onChanged: (v){floorController.text = v;hostel.floor=v;floorController.selection = TextSelection.fromPosition(TextPosition(offset: floorController.text.length));},
                                            decoration: InputDecoration(
                                              labelText: 'Floor',
                                              labelStyle: TextStyle(color: Color.fromRGBO(110, 119, 138, 1), fontWeight: FontWeight.w600),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(110, 119, 138, 1),
                                                    width: 1
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                                borderSide: BorderSide(
                                                  color: Color.fromRGBO(110, 119, 138, 1),
                                                  width: 1,
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ) :
                                (i==7)?IpPage(argso: hostel)
                                    :Text('Insert Image here'),
                              ],
                            );
                          },
                        );
                      }).toList(),
                      carouselController: _buttonCarouselController,
                      options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          aspectRatio: 0.8,
                          initialPage: 0,
                          scrollPhysics: NeverScrollableScrollPhysics()
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if(page != 1)
                            {
                              await _buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                              setState(() {
                                page = page -1;
                              });
                            }

                          },
                          icon: Icon(Icons.chevron_left,color: page!=1?Color.fromRGBO(235, 241,255,1):Color.fromRGBO(110, 119, 138, 1),),
                        ),
                        IconButton(
                          onPressed: () async {
                            if(page < 8 && page != 6)
                            {
                              await _buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                              setState(() {
                                page = page+1;
                              });
                            }
                            else if(page == 6)
                            {
                              if(dropdownValue != 'Select Hostel')
                              {
                                if (_keyform.currentState!.validate()){
                                  fg=false;
                                  await _buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                                  setState(() {
                                    page = page+1;
                                  });
                                }
                              }

                            }
                          },
                          icon: Icon(Icons.chevron_right, color: page!=8?Color.fromRGBO(235, 241,255,1):Color.fromRGBO(110, 119, 138, 1),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
