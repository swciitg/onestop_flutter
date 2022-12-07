import 'dart:collection';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_details.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:onestop_dev/widgets/contact/contact_page_button.dart';
import 'package:onestop_dev/widgets/contact/contact_search_bar.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';

import 'contact_detail.dart';

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
          title:
              Text('Contacts', style: MyFonts.w500.size(20).setColor(kWhite)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                FluentIcons.dismiss_24_filled,
              ),
            )
          ],
        ),
        body: Provider<ContactStore>(
          create: (context) => ContactStore(),
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                  child: ContactSearchBar(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 16,
                        child: Container(),
                      ),
                      ContactPageButton(
                        label: 'Emergency',
                        store: context.read<ContactStore>(),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                      ContactPageButton(
                        label: "Transport",
                        store: context.read<ContactStore>(),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                      ContactPageButton(
                        label: 'Gymkhana',
                        store: context.read<ContactStore>(),
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
                      const Icon(
                        FluentIcons.star_12_filled,
                        color: kGrey8,
                        size: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Starred',
                          style: MyFonts.w400.setColor(kGrey8),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future:
                        context.read<ContactStore>().getAllStarredContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ContactDetailsModel> stars =
                            snapshot.data as List<ContactDetailsModel>;
                        context.read<ContactStore>().setStarredContacts(stars);
                        return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Observer(builder: (context) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: context
                                      .read<ContactStore>()
                                      .starContactScroll);
                            }));
                      }
                      return Container();
                    }),
                Expanded(
                  child: FutureBuilder<SplayTreeMap<String, ContactModel>>(
                    future: DataProvider.getContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        SplayTreeMap<String, ContactModel> people =
                            snapshot.data!;
                        List<String> alphabets = [];
                        people.forEach((key, value) {
                          if (!alphabets.contains(key[0].toUpperCase())) {
                            alphabets.add(key[0].toUpperCase());
                          }
                        });
                        for (var e in alphabets) {
                          people["$e ADONOTUSE"] = ContactModel(
                              name: "Random", contacts: [], group: "");
                        }
                        return AlphabetScrollView(
                          list: people.keys.map((e) => AlphaModel(e)).toList(),
                          alignment: LetterAlignment.right,
                          itemExtent: 50,
                          unselectedTextStyle:
                              MyFonts.w500.size(11).setColor(kGrey7),
                          selectedTextStyle:
                              MyFonts.w500.size(11).setColor(kGrey7),
                          itemBuilder: (context, k, id) {
                            var contactStore = context.read<ContactStore>();
                            if (id.contains(" ADONOTUSE")) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 22,
                                    child: Container(
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: kAppBarGrey),
                                        ),
                                      ),
                                      child: Text(
                                        id[0],
                                        style: MyFonts.w500
                                            .setColor(kWhite3)
                                            .size(11),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 2, child: Container()),
                                ],
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Provider<ContactStore>.value(
                                      value: contactStore,
                                      child: ContactDetailsPage(
                                          contact: people[id], title: 'Campus'),
                                    );
                                  }));
                                },
                                child: ListTile(
                                    title: Text(
                                  id,
                                  style: MyFonts.w600.setColor(kWhite).size(14),
                                )),
                              ),
                            );
                          },
                        );
                      }
                      return ListShimmer(
                        height: 50,
                        count: 20,
                      );
                    },
                  ),
                )
              ],
            );
          },
        ));
  }
}
