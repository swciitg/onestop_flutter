import 'package:flutter/material.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class Contacts2 extends StatefulWidget {
  final Contacts10;
  final String title;
  final String subtitle;
  const Contacts2({Key? key,  this.Contacts10, required this.title, required this.subtitle}) : super(key: key);
  @override
  State<Contacts2> createState() => _Contacts2State();
}



class _Contacts2State extends State<Contacts2> {

  List<Map<String, dynamic>> _contact = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contact.clear();
    for(final item in widget.Contacts10)
      {
        _contact.add({'name': item['name'], 'email': item['email'], 'contact': item['contact']});
      }
    //print(_contact);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          leading: Container(),
          leadingWidth: 0,
          title: Text(
              'Contacts',
              style: MyFonts.medium.size(20).setColor(kWhite)
          ),
          actions: [
            IconButton(
                onPressed: () {Navigator.of(context).pop();},
                icon: Icon(IconData(0xe16a, fontFamily: 'MaterialIcons')))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.subtitle,
                      style: TextStyle(
                          color: kWhite,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: kFontGrey,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2),
                  child: Text(
                    widget.Contacts10!.length.toString()+' contacts',
                    style: TextStyle(
                      color: kFontGrey,
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    alignment: AlignmentDirectional.topStart,
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: kFontGrey,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    child: Text(
                      'Email id',
                      style: TextStyle(
                        color: kFontGrey,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    width: MediaQuery.of(context).size.width / 3 - 15,
                    child: Text(
                      'Contact No',
                      style: TextStyle(
                        color: kFontGrey,
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.96,
              child: Divider(
                color: Colors.blueGrey,
                thickness: 1,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _contact.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              alignment: AlignmentDirectional.topStart,
                              width: MediaQuery.of(context).size.width / 3 - 10,
                              child: Text(
                                item['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3 - 10,
                              child: Text(
                                item['email'],
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              alignment: AlignmentDirectional.bottomEnd,
                              width: MediaQuery.of(context).size.width / 3 - 15,
                              child: Text(
                                item['contact'].toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

