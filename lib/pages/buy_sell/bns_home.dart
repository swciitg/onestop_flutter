import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/ads_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_dev/widgets/buy_sell/utility.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:provider/provider.dart';

class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";
  const BuySellHome({Key? key}) : super(key: key);

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  StreamController selectedTypeController = StreamController();
  late Stream typeStream;

  @override
  void initState() {
    super.initState();
    typeStream = selectedTypeController.stream.asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
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
          future: getItems(context.read<LoginStore>().userData['email']),
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
              return StreamBuilder(
                stream: typeStream,
                builder: (context, AsyncSnapshot snapshot) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (snapshot.hasData &&
                                    snapshot.data! != "Sell") {
                                  selectedTypeController.sink.add("Sell");
                                }
                              },
                              child: ItemTypeBar(
                                text: "Sell",
                                margin:
                                    const EdgeInsets.only(left: 16, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    snapshot.hasData == false
                                        ? kBlack
                                        : (snapshot.data! == "Sell"
                                            ? kBlack
                                            : kWhite)),
                                backgroundColor: snapshot.hasData == false
                                    ? lBlue2
                                    : (snapshot.data! == "Sell"
                                        ? lBlue2
                                        : kBlueGrey),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!snapshot.hasData) {
                                  selectedTypeController.sink.add("Buy");
                                }
                                if (snapshot.hasData &&
                                    snapshot.data! != "Buy") {
                                  selectedTypeController.sink.add("Buy");
                                }
                              },
                              child: ItemTypeBar(
                                text: "Buy",
                                margin:
                                    const EdgeInsets.only(left: 8, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    snapshot.hasData == false
                                        ? kWhite
                                        : (snapshot.data! == "Buy"
                                            ? kBlack
                                            : kWhite)),
                                backgroundColor: snapshot.hasData == false
                                    ? kBlueGrey
                                    : (snapshot.data! == "Buy"
                                        ? lBlue2
                                        : kBlueGrey),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!snapshot.hasData) {
                                  selectedTypeController.sink.add("My Ads");
                                }
                                if (snapshot.hasData &&
                                    snapshot.data! != "My Ads") {
                                  selectedTypeController.sink.add("My Ads");
                                }
                              },
                              child: ItemTypeBar(
                                text: "My Ads",
                                margin:
                                    const EdgeInsets.only(left: 8, bottom: 10),
                                textStyle: MyFonts.w500.size(14).setColor(
                                    snapshot.hasData == false
                                        ? kWhite
                                        : (snapshot.data! == "My Ads"
                                            ? kBlack
                                            : kWhite)),
                                backgroundColor: snapshot.hasData == false
                                    ? kBlueGrey
                                    : (snapshot.data! == "My Ads"
                                        ? lBlue2
                                        : kBlueGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: selectList(snapshot, buyItems, sellItems, myAds),
                      )
                    ],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddItemButton(
        typeStream: typeStream,
        initialData: "Sell",
      ),
    );
  }
}
