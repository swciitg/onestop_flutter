import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:onestop_dev/pages/lost_found/lnf_form.dart';
import 'package:timeago/timeago.dart' as timeago;

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";
  const LostFoundHome({Key? key}) : super(key: key);

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {
  StreamController selectedTypeController = StreamController();
  final globalKey = GlobalKey<ScaffoldState>();

  Future<List> getLostItems() async {
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
    var res = await http
        .get(Uri.parse('https://swc.iitg.ac.in/onestopapi/found'));
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
          future: getLostItems(),
          builder: (context, lostsSnapshot) {
            if (lostsSnapshot.hasData) {
              return FutureBuilder<List>(
                future: getFoundItems(),
                builder: (context, foundsSnapshot) {
                  if (foundsSnapshot.hasData) {
                    List<Widget> lostItems = [];
                    List<Widget> foundItems = [];
                    lostsSnapshot.data!.forEach((e) => {
                      lostItems.add(LostItemTile(
                          currentLostModel: LostModel.fromJson(e)))
                    });
                    foundsSnapshot.data!.forEach((e) => {
                      foundItems.add(FoundItemTile(
                          currentFoundModel: FoundModel.fromJson(e),homeKey: globalKey,))
                    });
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
                                          snapshot.data! != "Lost")
                                        selectedTypeController.sink.add("Lost");
                                    },
                                    child: ItemTypeBar(
                                      text: "Lost",
                                      margin:
                                      EdgeInsets.only(left: 16, bottom: 10),
                                      textStyle: MyFonts.w500.size(14).setColor(
                                          snapshot.hasData == false
                                              ? kBlack
                                              : (snapshot.data! == "Lost"
                                              ? kBlack
                                              : kWhite)),
                                      backgroundColor: snapshot.hasData == false
                                          ? lBlue2
                                          : (snapshot.data! == "Lost"
                                          ? lBlue2
                                          : kBlueGrey),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!snapshot.hasData)
                                        selectedTypeController.sink
                                            .add("Found");
                                      if (snapshot.hasData &&
                                          snapshot.data! != "Found")
                                        selectedTypeController.sink
                                            .add("Found");
                                    },
                                    child: ItemTypeBar(
                                      text: "Found",
                                      margin:
                                      EdgeInsets.only(left: 8, bottom: 10),
                                      textStyle: MyFonts.w500.size(14).setColor(
                                          snapshot.hasData == false
                                              ? kWhite
                                              : (snapshot.data! == "Found"
                                              ? kBlack
                                              : kWhite)),
                                      backgroundColor: snapshot.hasData == false
                                          ? kBlueGrey
                                          : (snapshot.data! == "Found"
                                          ? lBlue2
                                          : kBlueGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: (!snapshot.hasData ||
                                    snapshot.data! == "Lost")
                                    ? (lostItems.length == 0
                                    ? Center(
                                  child: Text(
                                    "No Lost Items as of now :)",
                                    style: MyFonts.w500
                                        .size(16)
                                        .setColor(kWhite),
                                  ),
                                )
                                    : ListView(
                                  children: lostItems,
                                ))
                                    : (foundItems.length == 0
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
                if (!snapshot.hasData || snapshot.data! == "Lost") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LostFoundForm(
                        category: "Lost",
                        imageString: imageString,
                      )));
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LostFoundLocationForm(
                      imageString: imageString,
                    )));
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
                          ? "Lost Item"
                          : (snapshot.data! == "Lost"
                          ? "Lost Item"
                          : "Found Item"),
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