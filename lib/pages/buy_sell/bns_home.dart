import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buysell/buy_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/widgets/buySell/ads_tile.dart';
import 'package:onestop_dev/widgets/buySell/buy_tile.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";
  const BuySellHome({Key? key}) : super(key: key);

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  StreamController selectedTypeController = StreamController();

  Future<List> getBuyItems() async {
    print("before");
    var res =
        await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/lost'));
    print("after");
    var lostItemsDetails = jsonDecode(res.body);
    print("decoded json");
    return lostItemsDetails["details"];
  }

  Future<List> getFoundItems() async {
    print("before");
    var res =
        await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/found'));
    print("after");

    var foundItemsDetails = jsonDecode(res.body);
    print("decoded json");
    return foundItemsDetails["details"];
  }

  @override
  Widget build(BuildContext context) {
    Stream typeStream = selectedTypeController.stream.asBroadcastStream();
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
          future: getBuyItems(),
          builder: (context, lostsSnapshot) {
            if (lostsSnapshot.hasData) {
              return FutureBuilder<List>(
                future: getBuyItems(),
                builder: (context, foundsSnapshot) {
                  print(foundsSnapshot.data);
                  if (foundsSnapshot.hasData) {
                    List<Widget> buyItems = [];
                    List<Widget> sellItems = [];
                    List<Widget> myAds = [];
                    lostsSnapshot.data!.forEach((e) => {
                          print("here"),
                          print(e["username"]),
                          buyItems.add(
                            BuyTile(
                              model: LostModel.fromJson(e),
                            ),
                          )
                        });
                    print("here 2");
                    foundsSnapshot.data!.forEach((e) => {
                          sellItems.add(MyAdsTile(model: LostModel.fromJson(e)))
                        });
                    print("here 3");
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
                                      margin:
                                          EdgeInsets.only(left: 16, bottom: 10),
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
                                      if (snapshot.hasData &&
                                          snapshot.data! != "Buy")
                                        selectedTypeController.sink.add("Buy");
                                    },
                                    child: ItemTypeBar(
                                      text: "Buy",
                                      margin:
                                          EdgeInsets.only(left: 8, bottom: 10),
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
                                        selectedTypeController.sink
                                            .add("My Ads");
                                      if (snapshot.hasData &&
                                          snapshot.data! != "My Ads")
                                        selectedTypeController.sink
                                            .add("My Ads");
                                    },
                                    child: ItemTypeBar(
                                      text: "My Ads",
                                      margin:
                                          EdgeInsets.only(left: 8, bottom: 10),
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
                              child: (!snapshot.hasData ||
                                      snapshot.data! == "Sell")
                                  ? (buyItems.length == 0
                                      ? Center(
                                          child: Text(
                                            "No Items on sell as of now :)",
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                          ),
                                        )
                                      : ListView(
                                          children: buyItems,
                                        ))
                                  : (sellItems.length == 0
                                      ? Center(
                                          child: Text(
                                            "No Items on Buy as of now :)",
                                            style: MyFonts.w500
                                                .size(16)
                                                .setColor(kWhite),
                                          ),
                                        )
                                      : ListView(
                                          children: sellItems,
                                        )),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
        stream: typeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return GestureDetector(
            onTap: () async {
              XFile? xFile;
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title:
                            Text("From where do you want to take the photo?"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text("Gallery"),
                                onTap: () async {
                                  xFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text("Camera"),
                                onTap: () async {
                                  xFile = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ));
                  });
              if (xFile != null) {
                var bytes = File(xFile!.path).readAsBytesSync();
                var imageSize =
                    (bytes.lengthInBytes / (1048576)); // dividing by 1024*1024
                if (imageSize > 2.5) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Maximum image size can be 2.5 MB")));
                  return;
                }
                var imageString = base64Encode(bytes);
                if (!snapshot.hasData || snapshot.data! == "Sell") {
                  print("Lost clicked");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuySellForm(
                            category: "Sell",
                            imageString: imageString,
                          )));
                  return;
                }
                print("Found clicked");
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => LostFoundLocationForm(
                //       imageString: imageString,
                //     )));
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: lBlue2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 17, bottom: 20, left: 20),
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 16, right: 20, bottom: 18),
                    child: Text(
                      !snapshot.hasData
                          ? "Sell Item"
                          : (snapshot.data! == "Sell"
                              ? "Sell Item"
                              : "Request Item"),
                      style: MyFonts.w600.size(14).setColor(kBlack),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ItemTypeBar extends StatelessWidget {
  final text;
  TextStyle textStyle;
  Color backgroundColor;
  EdgeInsets margin;
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

/*
Widget selectList(String type, List<Widget> buyList, List<Widget> sellList,
      List<Widget> myList) {
    List<Widget> finalList;
    if (type == "NULL") {
      return Center(
        child: Text(
          "No Items here as of now :)",
          style: MyFonts.w500.size(16).setColor(kWhite),
        ),
      );
    }
    if (type == "Sell") {
      finalList = sellList;
    } else if (type == "Sell") {
      finalList = buyList;
    } else {
      finalList = myList;
    }
    return (finalList.length == 0
        ? Center(
            child: Text(
              "No Items here as of now :)",
              style: MyFonts.w500.size(16).setColor(kWhite),
            ),
          )
        : ListView(
            children: finalList,
          ));
  }
  */