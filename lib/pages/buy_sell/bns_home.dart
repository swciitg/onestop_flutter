import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/functions/buysell/get_items.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/ads_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_dev/widgets/buy_sell/select_list.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:provider/provider.dart';

class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";
  const BuySellHome({Key? key}) : super(key: key);

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();
    return Observer(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kBlueGrey,
            title: Text(
              "Buy and Sell",
              style: MyFonts.w500.size(20).setColor(kWhite),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 18,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  IconData(0xe16a, fontFamily: 'MaterialIcons'),
                ),
              )
            ],
          ),
          body: FutureBuilder<List>(
              future:
                  getBuySellItems(context.read<LoginStore>().userData['email']),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  List<Widget> buyItems = [];
                  List<Widget> sellItems = [];
                  List<Widget> myAds = [];
                  try {
                    if (!(snapshot2.data![0].isEmpty)) {
                      snapshot2.data![0].forEach((e) => {
                            buyItems.add(
                              BuyTile(
                                model: BuyModel.fromJson(e),
                              ),
                            )
                          });
                    }
                    if (!(snapshot2.data![1].isEmpty)) {
                      snapshot2.data![1].forEach((e) => {
                            sellItems.add(
                              BuyTile(model: BuyModel.fromJson(e)),
                            ),
                          });
                    }
                    if (!(snapshot2.data![2].isEmpty)) {
                      snapshot2.data![2].forEach((e) => {
                            myAds.add(
                              MyAdsTile(
                                model: BuyModel.fromJson(e),
                              ),
                            )
                          });
                    }
                  } catch (e) {
                    return const Text('Some Error Occured');
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                commonStore.setBnsIndex("Sell");
                              },
                              child: ItemTypeBar(
                                text: "For Sale",
                                margin: const EdgeInsets.only(
                                    left: 16, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    (commonStore.bnsIndex == "Sell"
                                        ? kBlack
                                        : kWhite)),
                                backgroundColor:
                                (commonStore.bnsIndex == "Sell"
                                    ? lBlue2
                                    : kBlueGrey),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                commonStore.setBnsIndex("Buy");
                              },
                              child: ItemTypeBar(
                                text: "Requested Item",
                                margin: const EdgeInsets.only(
                                    left: 8, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    (commonStore.bnsIndex == "Buy"
                                        ? kBlack
                                        : kWhite)),
                                backgroundColor:
                                commonStore.bnsIndex == "Buy"
                                    ? lBlue2
                                    : kBlueGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                commonStore.setBnsIndex("My Ads");
                              },
                              child: ItemTypeBar(
                                text: "My Ads",
                                margin: const EdgeInsets.only(
                                    left: 8, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    commonStore.bnsIndex == "My Ads"
                                        ? kBlack
                                        : kWhite),
                                backgroundColor:
                                commonStore.bnsIndex == "My Ads"
                                    ? lBlue2
                                    : kBlueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: selectList(
                            commonStore, buyItems, sellItems, myAds),
                      )
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AddItemButton(
            type: commonStore.bnsIndex,
          ),
        );
      },
    );
  }
}
