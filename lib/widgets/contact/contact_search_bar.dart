import 'dart:collection';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_dialog.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class ContactSearchBar extends StatelessWidget {
  const ContactSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FutureBuilder<SplayTreeMap<String, ContactModel>>(
        future: DataService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var contactStore = context.read<ContactStore>();
            return GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: PeopleSearch(contactStore: contactStore, peopleSearch: snapshot.data!),
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  border: Border.all(color: OColor.gray200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Search Contacts (name, position etc)',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
                      ),
                    ),
                    const SizedBox(width: OSpacing.xs),
                    Icon(FluentIcons.search_12_regular, color: OColor.gray500, size: 16),
                  ],
                ),
              ),
            );
          }
          return ListShimmer(count: 1, height: 30);
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
      options: FuzzyOptions(findAllMatches: false, tokenize: false, threshold: 0.4),
    );
  }

  @override
  String get searchFieldLabel => 'Search keyword (name, position etc)';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: OColor.white,
      hintColor: OColor.gray400,
      textTheme: TextTheme(titleLarge: OTextStyle.bodySmall.copyWith(color: OColor.gray800)),
      appBarTheme: AppBarTheme(
        backgroundColor: OColor.white,
        elevation: 0,
        iconTheme: IconThemeData(color: OColor.gray800),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(FluentIcons.dismiss_24_regular, color: OColor.gray600),
      onPressed: () {
        if (query.isEmpty) {
          close(context, '');
        } else {
          query = '';
          showSuggestions(context);
        }
      },
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
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
  Widget buildResults(BuildContext context) => buildSuggestionsSuccess(suggestionsList);

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      final suggestion = suggestions[index];

      return ListTile(
        onTap: () {
          query = suggestion;
          var resultModel = peopleMap[suggestion];
          if (resultModel is ContactModel) {
            showContactCategorySheet(
              context,
              contactModel: resultModel,
              contactStore: contactStore,
            );
          } else {
            showContactProfileSheet(context, details: peopleMap[query], contactStore: contactStore);
          }
        },
        leading: Icon(FluentIcons.people_20_regular, color: OColor.gray500),
        title: RichText(
          text: TextSpan(
            text: suggestion,
            style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
          ),
        ),
      );
    },
  );
}
