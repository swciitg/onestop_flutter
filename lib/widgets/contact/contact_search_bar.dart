import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';

class ContactSearchBar extends StatelessWidget {
  const ContactSearchBar({
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
                        peopleSearch: snapshot.data!));
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
                      borderSide: const BorderSide(color: kBlueGrey, width: 1),
                    ),
                    filled: true,
                    prefixIcon: const Icon(
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

  late final SplayTreeMap<String, ContactModel> peopleSearch;
  late final HashMap<String, dynamic> peopleMap;
  late final Fuzzy<String> peopleFuse;
  List<String> suggestionsList = [];
  late ContactStore contactStore;

  PeopleSearch({required this.peopleSearch, required this.contactStore}) {
    peopleMap = HashMap<String, dynamic>();
    for (String key in peopleSearch.keys.toList()) {
      peopleMap[key] = peopleSearch[key];
      List<ContactDetailsModel> contactsList = peopleSearch[key]!.contacts;
      for (var c in contactsList) {
        if (!peopleMap.containsKey(c.name)) {
          peopleMap[c.name] = c;
        }
      }
    }
    List<String> people = peopleMap.keys.toList();
    peopleFuse = Fuzzy(
      people,
      options: FuzzyOptions(
        findAllMatches: false,
        tokenize: false,
        threshold: 0.4,
      ),
    );
  }


  @override
  String get searchFieldLabel => 'Search keyword (name, position etc)';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(27, 27, 29, 1),
      hintColor: kGrey2,
      textTheme: TextTheme(
        headline6: MyFonts.w600.setColor(kWhite).size(13),
      ),
      appBarTheme: const AppBarTheme(
        color: kBlueGrey,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
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
        icon: const Icon(
          Icons.arrow_back,
          color: kWhite,
        ),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = peopleFuse.search(query);
    final suggestions = result.map((e) => e.item).toList();
    suggestionsList = suggestions;
    return buildSuggestionsSuccess(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) =>
      buildSuggestionsSuccess(suggestionsList);

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            onTap: () {
              query = suggestion;
              var resultModel = peopleMap[suggestion];
              if (resultModel is ContactModel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Provider<ContactStore>.value(
                      value: contactStore,
                      child: ContactDetailsPage(
                        title: 'Campus',
                        contact: peopleMap[query],
                      ),
                    ),
                  ),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (_) => Provider<ContactStore>.value(
                          value: contactStore,
                          child: ContactDialog(details: peopleMap[query]),
                        ),
                    barrierDismissible: true);
              }
            },
            leading: const Icon(
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
