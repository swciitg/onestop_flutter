import 'dart:collection';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

class BnS_SearchBar extends StatefulWidget {
  final String bnsIndex;
  const BnS_SearchBar({
    required this.bnsIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<BnS_SearchBar> createState() => _BnS_SearchBarState();
}

class _BnS_SearchBarState extends State<BnS_SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FutureBuilder<SplayTreeMap<String, dynamic>>(
        future:
            widget.bnsIndex == "Sell" ? APIService().getSell() : APIService().getBuy(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                showSearch(
                    context: context,
                    delegate: BnSItemSearch(
                        bnsIndex: widget.bnsIndex == "Buy" ? "Buy" : "Sell",
                        bnsitemsearch: snapshot.data!));
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
                      FluentIcons.search_12_regular,
                      color: kWhite,
                      size: 12,
                    ),
                    hintStyle: MyFonts.w500.size(12).setColor(kGrey2),
                    hintText: widget.bnsIndex == "Buy"
                        ? "Search for the item you want to sell"
                        : "Search for the item you want to buy",
                    contentPadding: EdgeInsets.zero,
                    fillColor: kBlueGrey),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.white),
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

class BnSItemSearch extends SearchDelegate<String> {
  final String bnsIndex;
  late final SplayTreeMap<String, dynamic> bnsitemsearch;
  late final Fuzzy<String> itemsFuse;
  List<String> suggestionsList = [];

  BnSItemSearch({required this.bnsitemsearch, required this.bnsIndex}) {
    List<String> titles = bnsitemsearch.keys.toList();
    itemsFuse = Fuzzy(
      titles,
      options: FuzzyOptions(
        findAllMatches: false,
        tokenize: false,
        threshold: 0.4,
      ),
    );
  }

  @override
  String get searchFieldLabel => bnsIndex == "Buy"
      ? "Search for the item you want to sell"
      : "Search for the item you want to buy";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(27, 27, 29, 1),
      hintColor: kGrey2,
      focusColor: Colors.grey,
      textTheme: TextTheme(
        titleLarge: MyFonts.w600.setColor(kWhite).size(13),
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
            FluentIcons.dismiss_24_filled,
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
          FluentIcons.arrow_left_24_regular,
          color: kWhite,
        ),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final result = itemsFuse.search(query);
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
              var resultModel = bnsitemsearch[suggestion];
              if (resultModel is BuyModel || resultModel is SellModel) {
                detailsDialogBox(context, resultModel);
              } else {
                detailsDialogBox(context, bnsitemsearch[query]);
              }
            },
            leading: const Icon(
              FluentIcons.people_20_regular,
              color: kWhite,
            ),
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
