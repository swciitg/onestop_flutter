import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_button.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:provider/provider.dart';

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";
  const LostFoundHome({Key? key}) : super(key: key);

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {
  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          title: Text(
            "Lost and Found",
            style: MyFonts.w500.size(20).setColor(kWhite),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 18,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/dismiss_icon.png",
                height: 18,
              ),
            )
          ],
        ),
        // wrap column of body with future builder to fetch all lost and found
        body: FutureBuilder<List>(
            future: APIService.getLostItems(),
            builder: (context, lostsSnapshot) {
              if (lostsSnapshot.hasData) {
                return FutureBuilder<List>(
                  future: APIService.getFoundItems(),
                  builder: (context, foundsSnapshot) {
                    if (foundsSnapshot.hasData) {
                      List<Widget> lostItems = [];
                      List<Widget> foundItems = [];
                      for (var e in lostsSnapshot.data!) {
                        {
                          lostItems.add(LostFoundTile(
                              currentModel: LostModel.fromJson(e)));
                        }
                      }

                      for (var e in foundsSnapshot.data!) {
                        {
                          foundItems.add(LostFoundTile(
                            parentContext: context,
                            currentModel: FoundModel.fromJson(e),
                          ));
                        }
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                LostFoundButton(
                                  label: "Lost Items",
                                  store: commonStore,
                                  category: "Lost",
                                ),
                                LostFoundButton(
                                  store: commonStore,
                                  label: "Found Items",
                                  category: "Found",
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: (commonStore.lnfIndex == "Lost")
                                  ? (lostItems.isEmpty
                                      ? Center(
                                          child: Text(
                                            "No Lost Items",
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                          ),
                                        )
                                      : ListView(
                                          children: lostItems,
                                        ))
                                  : (foundItems.isEmpty
                                      ? Center(
                                          child: Text(
                                            "No found Items as of now :)",
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                          ),
                                        )
                                      : ListView(
                                          children: foundItems,
                                        )))
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListShimmer(
                        count: 10,
                        height: 120,
                      ),
                    );
                  },
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListShimmer(
                  count: 10,
                  height: 120,
                ),
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AddItemButton(
          type: commonStore.lnfIndex,
        ),
      );
    });
  }
}
