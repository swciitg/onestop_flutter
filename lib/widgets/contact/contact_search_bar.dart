import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/contact/contact.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';

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
                size: 12,
              ),
              hintStyle: MyFonts.medium.size(12).setColor(kGrey2),
              hintText: "Search keyword (name, position etc)",
              contentPadding: EdgeInsets.zero,
              fillColor: kBlueGrey),
        ),
      ),
    );
  }
}

class CitySearch extends SearchDelegate<String> {
  final cities = people.keys.toList();
  var x;

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
              builder: (BuildContext context) => Contacts2(title: 'Campus',contact: people[query],),
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
