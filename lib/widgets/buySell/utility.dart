import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';


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

  var myItemsDetails = jsonDecode(res.body);
  //print([...myItemsDetails["details"]["sellList"],...myItemsDetails["details"]["buyList"]].length);
  return [...myItemsDetails["details"]["sellList"],...myItemsDetails["details"]["buyList"]];
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
  return (finalList.isEmpty
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