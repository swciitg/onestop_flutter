import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/ip/ip_input.dart';
import 'package:onestop_dev/pages/ip/ip_settings.dart';
import 'package:onestop_dev/functions/ip/ip_decoration.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/functions/ip/ip_calculator.dart';

List<String> textdata = [
  'Open Start-> Control Panel -> Network and Internet-> Network and Sharing Center ',
  "Click on 'Manage wireless networks'",
  'Right click on \'Local area connection\' and then click on properties',
  'Uncheck \'Internet Protocol Version 6 (TCP/IPv6)\' and double click \'Internet Protocol Version 4 (TCP/IPv4)\'',
  'Select \'Use the following IP address\' and \'Use the following DNS server addresses\' Modify the DNS address as given below\nprimary DNS: 172.171.1.1\nsecondary DNS: 172.17.1.2',
  'Enter the following details to get your IP address',
  '',
  "Make sure the connection is no-proxy/direct connection. Open any website in your browser. It will show a captive portal asking your IITG login credentials.Login to the portal and start accessing internet using the same.If you have a problem while redirecting to login page, then use this link given below in your pc browser https://agnigarh.iitg.ac.in:1442/login?",
  'You might need to change some of your laptop settings before you could start using the internet in your room. Go through the following steps after connecting your laptop to the LAN port. '
];
bool fg = true;

class RouterPage extends StatefulWidget {
  static String id = "/ip";
  const RouterPage({Key? key}) : super(key: key);
  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int page = 1;
  Widget seven = Column();
  CarouselController _buttonCarouselController = CarouselController();
  TextEditingController roomController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  hostelDetails hostel =
      hostelDetails("nothing", "--", "--=-=-===", "something");
  String dropdownValue = "Select Hostel";
  List<String> spinnerItems = [
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
  ];
  final _keyform = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      page = 1;
    });
  }

  function(argso) {
    setState(() {
      seven = IpPage(argso: argso);
    });
  }

  @override
  Widget build(BuildContext context) {
    double HEIGHT = MediaQuery.of(context).size.height;
    double WIDTH = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: kAppBarGrey,
        leading: Container(),
        leadingWidth: 0,
        title: Text(
          'Internet Settings',
          style: MyFonts.w500.setColor(kWhite),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(IconData(0xe16a, fontFamily: 'MaterialIcons')))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Text(
                  textdata[8],
                  style: MyFonts.w600.size(14).setColor(kGrey8),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: 520,
                width: WIDTH * 0.95,
                decoration: BoxDecoration(
                    color: kAppBarGrey,
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CarouselSlider(
                        items: [1, 2, 3, 4, 5, 6, 7, 8].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Step $i of 8',
                                          style: MyFonts.w600
                                              .size(16)
                                              .setColor(kWhite),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    textdata[i - 1],
                                    style:
                                        MyFonts.w400.size(14).setColor(kGrey6),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  (i == 6)
                                      ? Form(
                                          key: _keyform,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        canvasColor: kBlueGrey),
                                                child: SizedBox(
                                                  height: 58,
                                                  child: Center(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: dropdownValue,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      style: MyFonts.w500
                                                          .size(16)
                                                          .setColor(kWhite),
                                                      onChanged: (data) {
                                                        setState(() {
                                                          dropdownValue = data!;
                                                          hostel.hostelName =
                                                              dropdownValue;
                                                        });
                                                        //print(hostel);
                                                      },
                                                      decoration:
                                                          decfunction(''),
                                                      items: spinnerItems.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: MyFonts.w500
                                                                .size(15)
                                                                .setColor(
                                                                    kWhite),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              IpField(
                                                texta:
                                                    "Remember your room number correctly",
                                                textb: 'Room Number',
                                                hostel: hostel,
                                                control: roomController,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              IpField(
                                                texta:
                                                    "remember your block number correctly",
                                                textb: 'Block',
                                                hostel: hostel,
                                                control: blockController,
                                              ),
                                              SizedBox(height: 10),
                                              IpField(
                                                texta:
                                                    "remember your floor number correctly",
                                                textb: 'Floor',
                                                hostel: hostel,
                                                control: floorController,
                                              ),
                                            ],
                                          ),
                                        )
                                      : (i == 7)
                                          ? seven
                                          : (i == 5)
                                              ? InteractiveViewer(
                                                  //panEnabled: false, // Set it to false
                                                  minScale: 0.5,
                                                  maxScale: 4,
                                                  child: Image.asset(
                                                    'assets/images/lan5.png',
                                                    height: 260,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : (i == 4)
                                                  ? Image.asset(
                                                    'assets/images/lan4.png',
                                                    height: 290,
                                                  )
                                                  : (i != 8)
                                                      ? Image.asset(
                                                          'assets/images/lan' +
                                                              i.toString() +
                                                              '.png')
                                                      : SizedBox(
                                                          height: HEIGHT * 0,
                                                        )
                                ],
                              );
                            },
                          );
                        }).toList(),
                        carouselController: _buttonCarouselController,
                        options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                page = index + 1; //<-- Page index
                              });
                            },
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 0.95,
                            height: 445,
                            initialPage: 0,
                            scrollPhysics: NeverScrollableScrollPhysics()),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (page != 1) {
                                if (page == 6) {
                                  setState(() {
                                    seven = Column();
                                  });
                                }
                                await _buttonCarouselController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              }
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              color: page != 1 ? kWhite2 : kGrey7,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (page < 8 && page != 6) {
                                await _buttonCarouselController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              } else if (page == 6) {
                                if (dropdownValue != 'Select Hostel') {
                                  if (_keyform.currentState!.validate()) {
                                    function(hostel);
                                    fg = false;
                                    await _buttonCarouselController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  }
                                }
                              }
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              color: page != 8 ? kWhite2 : kGrey7,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
