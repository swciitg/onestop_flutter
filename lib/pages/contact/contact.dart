import 'dart:collection';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'contact_detail.dart';
import 'package:onestop_dev/widgets/contact/contact_search_bar.dart';

// SplayTreeMap<String, ContactModel> people= SplayTreeMap();
// SplayTreeMap<String, ContactModel> people_search= SplayTreeMap();
List<String> alphabets = [  "A",  "B",  "C",  "D",  "E",  "F", "I",  "L",  "M",  "N",  "O",  "P",  "Q",  "R",  "S",  "T",  "U",  "V"];

class ContactPage extends StatefulWidget {
  static String id = "/contacto";
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}
class _ContactPageState extends State<ContactPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          leading: Container(),
          leadingWidth: 0,
          title: Text(
              'Contacts',
              style: MyFonts.w500.size(20).setColor(kWhite)
          ),
          actions: [
            IconButton(
                onPressed: () {Navigator.of(context).pop();},
                icon: Icon(IconData(0xe16a, fontFamily: 'MaterialIcons')))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8,14,8,14),
              child: ContactSearchBar(),
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0, 0,0,10),
              child: Row(
                children: [
                  Expanded(flex: 16, child: Container(),),
                  Expanded(
                    flex: 106,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lGrey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, color: kGrey8,),
                          Text('Emergency', style: MyFonts.medium.size(10).setColor(kWhite),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 5, child: Container(),),
                  Expanded(
                    flex: 106,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lGrey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_bus, color: kGrey8,),
                          Text('Transport', style: MyFonts.medium.size(10).setColor(kWhite),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 5, child: Container(),),
                  Expanded(
                    flex: 106,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: lGrey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group, color: kGrey8,),
                          Text('Gymkhana', style: MyFonts.medium.size(10).setColor(kWhite),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 16, child: Container(),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: Row(
                children: [
                  Icon(IconData(0xe5f9, fontFamily: 'MaterialIcons'), color: kGrey8, size: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Starred', style: MyFonts.regular.setColor(kGrey8),),
                  ),
                  Expanded(child: Container(),),
                ],
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      starredContact('Gensec SWC'),
                      starredContact('Admin, Finance'),
                      starredContact('Gensec SWC'),
                      starredContact('Admin, Finance'),
                      starredContact('Gensec SWC'),
                      starredContact('Admin, Finance'),
                    ]
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(3,0,3,0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage('https://images.wallpapersden.com/image/wxl-loki-marvel-comics-show_78234.jpg'),
                ),
                title: Text('My Profile', style: MyFonts.medium.size(15).setColor(kWhite),),
              ),
            ),*/
            Expanded(
              child: FutureBuilder<SplayTreeMap<String,ContactModel>>(
                future: DataProvider.getContacts(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    SplayTreeMap<String,ContactModel> people = snapshot.data!;
                    alphabets.forEach((e)=>people[e+"ADONOTUSE"]=ContactModel(name: "Random", contacts: [], group: ""));
                    return AlphabetScrollView(
                      list: people.keys.map((e) => AlphaModel(e)).toList(),
                      alignment: LetterAlignment.right,
                      itemExtent: 50,
                      unselectedTextStyle: MyFonts.w500.size(11).setColor(kGrey7),
                      selectedTextStyle: MyFonts.w500.size(11).setColor(kGrey7),
                      /*overlayWidget: (value) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.circle, size: 30, color: Colors.grey,),
                      Container(
                        height: 50, width: 50,
                        decoration: BoxDecoration(shape: BoxShape.rectangle,),
                        alignment: Alignment.center,
                        child: Text('$value'.toUpperCase(), style: MyFonts.medium.size(15).setColor(kWhite),),
                      ),
                    ],
                  ),*/
                      itemBuilder: (_, k, id) {
                        if (id.contains("ADONOTUSE")) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 22,
                                child: Container(
                                  child: Text(id[0],style: MyFonts.w500.setColor(kWhite3).size(11),),
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1, color: kAppBarGrey),
                                    ),
                                  ),),
                              ),
                              Expanded(flex: 2, child: Container()),
                            ],
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts2(contact: people[id], title: 'Campus')),);},
                            child: ListTile(title: Text(id, style: MyFonts.w600.setColor(kWhite).size(14),)),
                          ),
                        );
                      },
                    );
                  }
                  return ListShimmer(height: 50,count: 20,);
                },
              ),
            )
          ],
        )
    );
  }
}


