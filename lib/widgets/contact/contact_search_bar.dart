import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';

class ContactSearchBar extends StatelessWidget {
  ContactSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FutureBuilder<SplayTreeMap<String, ContactModel>>(
        future: DataProvider.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var contactStore = context.read<ContactStore>();
            return GestureDetector(
              onTap: () {
                showSearch(
                    context: context,
                    delegate: PeopleSearch(
                        contactStore: contactStore,
                        people_search: snapshot.data!));
              },
              child: TextField(
                enabled: false,
                textAlignVertical: TextAlignVertical.center,
                style: MyFonts.w500.setColor(kWhite),
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
                    hintStyle: MyFonts.w500.size(12).setColor(kGrey2),
                    hintText: "Search keyword (name, position etc)",
                    contentPadding: EdgeInsets.zero,
                    fillColor: kBlueGrey),
              ),
            );
          }
          return ListShimmer(
            count: 1,
            height: 30,
          );
        },
      ),
    );
  }
}

class PeopleSearch extends SearchDelegate<String> {
  PeopleSearch({required this.people_search, required this.contactStore}) {
    people = people_search.keys.toList();
  }

  late final SplayTreeMap<String, ContactModel> people_search;
  late final List<String> people;
  var x;
  late ContactStore contactStore;

  @override
  String get searchFieldLabel => 'Search keyword (name, position etc)';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Color.fromRGBO(27, 27, 29, 1),
      hintColor: kGrey2,
      textTheme: TextTheme(
        headline6: MyFonts.w600.setColor(kWhite).size(13),
      ),
      appBarTheme: AppBarTheme(
        color: kBlueGrey,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(
            Icons.clear,
            color: kWhite,
          ),
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
        icon: Icon(
          Icons.arrow_back,
          color: kWhite,
        ),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = people.where((peps) {
      final peopleLower = peps.toLowerCase();
      final queryLower = query.toLowerCase();
      return peopleLower.contains(queryLower);
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
                  builder: (BuildContext context) =>
                      Provider<ContactStore>.value(
                    value: contactStore,
                    child: ContactDetailsPage(
                      title: 'Campus',
                      contact: people_search[query],
                    ),
                  ),
                ),
              );
            },
            leading: Icon(
              Icons.people,
              color: kWhite,
            ),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: suggestion,
                style: MyFonts.w600.setColor(kWhite).size(14),
              ),
            ),
          );
        },
      );
}
