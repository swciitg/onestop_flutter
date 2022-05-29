import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/pages/contact2.dart';
import '../globals/my_colors.dart';
import '../globals/my_fonts.dart';

List<String> list = [];
var namedetails = {};

class ContactPage extends StatefulWidget {
  static String id = "/contacto";
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  var _items = [];
  var namedetailso = {};

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/globals/contacts.json');
    final data = await json.decode(response);
    setState(() {
      _items = data;
    });

    _items.forEach((element) => list.add(element['name']));
    _items.forEach((element) => namedetails[element['name']] = element['contacts']);

    print(list);
    print(namedetails);
  }

  @override
  void initState() {
    // TODO: implement initState
    list = [];
    namedetails = {};
    super.initState();
    readJson();
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
              style: MyFonts.medium.size(20).setColor(kWhite)
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0,0,10),
              child: Row(
                children: [
                  Expanded(
                    flex: 16,
                    child: Container(),
                  ),
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
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
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
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
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
                  Expanded(
                    flex: 16,
                    child: Container(),
                  ),
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
                  Expanded(
                    child: Container(),
                  ),
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
                title: Text('My Profile', style: MyFonts.bold.size(15).setColor(kWhite),),
              ),
            ),
            Expanded(
              child: AlphabetScrollView(
                list: list.map((e) => AlphaModel(e)).toList(),
                alignment: LetterAlignment.right,
                itemExtent: 50,
                unselectedTextStyle: MyFonts.regular.size(12).setColor(kbg),
                selectedTextStyle: MyFonts.bold.size(12).setColor(kbg),
                overlayWidget: (value) => Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 30,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 50, width: 50,
                      decoration: BoxDecoration(shape: BoxShape.circle,),
                      alignment: Alignment.center,
                      child: Text(
                        '$value'.toUpperCase(),
                        style: TextStyle(fontSize: 18, color: kWhite),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (_, k, id) {
                  print('id'+id.toString());
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Contacts2(Contacts10: namedetails[id], title: 'Campus', subtitle: id,)),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          '$id',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        )
    );
  }
}

class ContactSearchBar extends StatelessWidget {

  ContactSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: GestureDetector(
        onTap: (){
          showSearch(context: context, delegate: CitySearch());
        },
        child: TextField(
          enabled: false,
          textAlignVertical: TextAlignVertical.center,
          style: MyFonts.medium.setColor(kWhite),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.0),
                borderSide: BorderSide(color: kBlueGrey, width: 1),
              ),
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: kWhite,
              ),
              hintStyle: MyFonts.medium.size(13).setColor(kGrey2),
              hintText: "Search keyword (name, position etc)",
              contentPadding: EdgeInsets.zero,
              fillColor: kBlueGrey),
        ),
      ),
    );
  }
}

class CitySearch extends SearchDelegate<String> {
  final cities = list;
  var x ;

  @override
  String get searchFieldLabel => 'Search keyword (name, position etc)';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Color.fromRGBO(27, 27, 29, 1),
      hintColor: kGrey2,
      appBarTheme: AppBarTheme(
        color: kBlueGrey, toolbarTextStyle: TextTheme(
          headline6: TextStyle( // headline 6 affects the query text
              color: kGrey2,
              fontSize: 12.0,
              fontWeight: FontWeight.bold)).bodyText2,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear, color: kWhite,),
      onPressed: () {
        if (query.isEmpty) {
          close(context, '');
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    )
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back, color: kWhite,),
    onPressed: () => close(context, ''),
  );



  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = cities.where((city) {
      final cityLower = city.toLowerCase();
      final queryLower = query.toLowerCase();
      return cityLower.contains(queryLower);
    }).toList();
    x = suggestions;
    return buildSuggestionsSuccess(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestionsSuccess(x);


  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      final suggestion = suggestions[index];
      //final queryText = suggestion.substring(0, query.length);
      //final remainingText = suggestion.substring(query.length);

      return ListTile(
        onTap: () {
          query = suggestion;

          // 1. Show Results
          //showResults(context);

          // 2. Close Search & Return Result
          close(context, suggestion);

          // 3. Navigate to Result Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Contacts2(title: 'Campus', subtitle: query, Contacts10: namedetails[query],),
            ),
          );
        },
        leading: Icon(Icons.people, color: kWhite,),
        // title: Text(suggestion),
        title: RichText(
          text: TextSpan(
            text: suggestion,
            style: MyFonts.regular.size(15).setColor(kWhite),
          ),
        ),
      );
    },
  );
}

starredContact(String contact)
{
  int size = contact.length;
  return TextButton(
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      child: Container(
        height: 32,
        width: 10*size+25,
        color: lGrey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contact,
              style: MyFonts.regular.setColor(kWhite),
            ),
          ],
        ),
      ),
    ), onPressed: (){},);
}

