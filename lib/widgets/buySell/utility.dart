import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';

Future<List> getBuyItems() async {
  var res = await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/buy'));
  var lostItemsDetails = jsonDecode(res.body);
  return lostItemsDetails["details"];
}

Future<List> getSellItems() async {
  var res = await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/sell'));
  var foundItemsDetails = jsonDecode(res.body);
  return foundItemsDetails["details"];
}

Future<List> getMyItems(mail) async {
  var res = await http.post(
      Uri.parse('https://swc.iitg.ac.in/onestopapi/myads'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': mail}));

  var MyItemsDetails = jsonDecode(res.body);
  //print([...MyItemsDetails["details"]["sellList"],...MyItemsDetails["details"]["buyList"]].length);
  return [...MyItemsDetails["details"]["sellList"],...MyItemsDetails["details"]["buyList"]];
}

Future<List> getItems(mail) async {
  var list1 = await getBuyItems();
  var list2 = await getSellItems();
  var list3 = await getMyItems(mail);
  return [list1, list2, list3];
}

Widget selectList(dynamic snapshot, List<Widget> buyList, List<Widget> sellList,
    List<Widget> myList) {
  List<Widget> finalList;
  if (snapshot.hasData == Null) {
    return Center(
      child: Text(
        "No Items here as of now :)",
        style: MyFonts.w500.size(16).setColor(kWhite),
      ),
    );
  }
  if (!snapshot.hasData || snapshot.data! == "Sell") {
    finalList = sellList;
  } else if (!snapshot.hasData || snapshot.data! == "Buy") {
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

Widget AddButton(Stream<dynamic> typeStream) {
  return StreamBuilder(
    stream: typeStream,
    initialData: "Buy",
    builder: (context, AsyncSnapshot snapshot) {
      print("The snapshot data in AddButton Widget is ");
      print(snapshot.data);
      if (snapshot.data == "My Ads") {
        return Container();
      }
      return GestureDetector(
        onTap: () async {
          XFile? xFile;
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("From where do you want to take the photo?"),
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
                  content: Text(
                "Maximum image size can be 2.5 MB",
                style: MyFonts.w500,
              )));
              return;
            }
            var imageString = base64Encode(bytes);
            if (snapshot.data == "Sell")
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuySellForm(
                        category: "Sell",
                        imageString: imageString,
                      )));
              return;
            }
            else if (snapshot.data == "Buy")
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuySellForm(
                        category: "Buy",
                        imageString: imageString,
                      )));
              return;
            }
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
                padding: const EdgeInsets.only(top: 17, bottom: 20, left: 20),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 16, right: 20, bottom: 18),
                child: Text(
                  snapshot.data! == "Sell" ? "Sell Item" : "Request Item",
                  style: MyFonts.w600.size(14).setColor(kBlack),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
