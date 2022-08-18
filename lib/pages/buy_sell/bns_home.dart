import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buysell/buy_model.dart';
import 'package:onestop_dev/widgets/buySell/ads_tile.dart';
import 'package:onestop_dev/widgets/buySell/buy_tile.dart';
import 'package:onestop_dev/widgets/buySell/utility.dart';

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
            icon: Icon(
              IconData(0xe16a, fontFamily: 'MaterialIcons'),
            ),
          )
        ],
      ),
      body: FutureBuilder<List>(
          future: getItems(),
          builder: (context, Snapshot) {
            if (Snapshot.hasData) {
              List<Widget> buyItems = [];
              List<Widget> sellItems = [];
              List<Widget> myAds = [];
              try{
              if (!(Snapshot.data![0].isEmpty)) {
                Snapshot.data![0].forEach((e) => {
                      buyItems.add(
                        BuyTile(
                          model: BuyModel.fromJson(e),
                        ),
                      )
                    });
              }
              if (!(Snapshot.data![2].isEmpty)) {
                Snapshot.data![2].forEach((e) => {
                      sellItems.add(
                        BuyTile(model: BuyModel.fromJson(e)),
                      ),
                    });
              }
              if (!(Snapshot.data![1].isEmpty)) {
                Snapshot.data![1].forEach((e) => {
                      myAds.add(
                        MyAdsTile(
                          model: BuyModel.fromJson(e),
                        ),
                      )
                    });
              }}
              catch(e){
                print(e);
                return Text('Some Error Occured');
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
                                    snapshot.data! != "Sell")
                                  selectedTypeController.sink.add("Sell");
                              },
                              child: ItemTypeBar(
                                text: "Sell",
                                margin: EdgeInsets.only(left: 16, bottom: 10),
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
                                if (!snapshot.hasData)
                                  selectedTypeController.sink.add("Buy");
                                if (snapshot.hasData && snapshot.data! != "Buy")
                                  selectedTypeController.sink.add("Buy");
                              },
                              child: ItemTypeBar(
                                text: "Buy",
                                margin: EdgeInsets.only(left: 8, bottom: 10),
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
                                if (!snapshot.hasData)
                                  selectedTypeController.sink.add("My Ads");
                                if (snapshot.hasData &&
                                    snapshot.data! != "My Ads")
                                  selectedTypeController.sink.add("My Ads");
                              },
                              child: ItemTypeBar(
                                text: "My Ads",
                                margin: EdgeInsets.only(left: 8, bottom: 10),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddButton(typeStream),
    );
  }
}

class ItemTypeBar extends StatelessWidget {
  final text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final EdgeInsets margin;
  ItemTypeBar(
      {Key? key,
      required this.text,
      required this.textStyle,
      required this.backgroundColor,
      required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(100)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
