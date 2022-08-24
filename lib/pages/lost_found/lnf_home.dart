import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_button.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";
  const LostFoundHome({Key? key}) : super(key: key);

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {
  StreamController selectedTypeController = StreamController();
  late Stream typeStream;

  @override
  void initState() {
    super.initState();
    typeStream = selectedTypeController.stream.asBroadcastStream();
  }

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
    var res =
        await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/found'));
    print("after");

    var foundItemsDetails = jsonDecode(res.body);
    print("decoded json");
    return foundItemsDetails["details"];
  }

  @override
  Widget build(BuildContext context) {
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
                  print(foundsSnapshot.data);
                  if (foundsSnapshot.hasData) {
                    List<Widget> lostItems = [];
                    List<Widget> foundItems = [];
                    lostsSnapshot.data!.forEach((e) => {
                          print("here"),
                          print(e["username"]),
                          lostItems.add(LostItemTile(
                              currentLostModel: LostModel.fromJson(e)))
                        });
                    print("here 2");
                    foundsSnapshot.data!.forEach((e) => {
                          foundItems.add(FoundItemTile(
                            parentContext: context,
                            currentFoundModel: FoundModel.fromJson(e),
                          ))
                        });
                    print("here 3");
                    return StreamBuilder(
                      stream: typeStream,
                      initialData: "Lost",
                      builder: (context, AsyncSnapshot snapshot) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  LostFoundButton(
                                    label: "Lost Items",
                                    snapshot: snapshot,
                                    selectedTypeController: selectedTypeController,
                                    category: "Lost",
                                  ),
                                  LostFoundButton(
                                    selectedTypeController: selectedTypeController,
                                    snapshot: snapshot,
                                    label: "Found Items",
                                    category: "Found",
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
                                              "No Lost Items",
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
                height:  120,
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddItemButton(
        typeStream: typeStream,
        initialData: 'Lost',
      ),
    );
  }
}
