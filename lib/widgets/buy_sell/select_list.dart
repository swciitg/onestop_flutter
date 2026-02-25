import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

Widget selectList(dynamic store, List<Widget> buyList, List<Widget> sellList, List<Widget> myList) {
  List<Widget> finalList;

  if (store.bnsIndex == "Sell") {
    finalList = sellList;
  } else if (store.bnsIndex == "Buy") {
    finalList = buyList;
  } else {
    finalList = myList;
  }
  return (finalList.isEmpty
      ? Center(
        child: Text(
          "No Items here as of now :)",
          style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
        ),
      )
      : ListView.builder(
        itemBuilder: (context, index) => finalList[index],
        itemCount: finalList.length,
      ));
}
