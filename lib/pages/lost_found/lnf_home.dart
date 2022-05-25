import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';
import 'package:onestop_dev/pages/lost_found/lnf_form.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";
  const LostFoundHome({Key? key}) : super(key: key);

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {

  StreamController selectedTypeController = StreamController();

  
  Future<List> getLostItems() async {
    print("before");
    var res = await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/all_lost'));
    print("after");
    var lostItemsDetails = jsonDecode(res.body);
    print("decoded json");
    return lostItemsDetails["details"];
  }

  Future<List> getFoundItems() async {
    print("before");
    var res = await http.get(Uri.parse('https://swc.iitg.ac.in/onestopapi/all_found'));
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
          style: MyFonts.medium.size(20).setColor(kWhite),
        ),
        elevation: 0,
      ),
      // wrap column of body with future builder to fetch all lost and found
      body: FutureBuilder<List>(
        future: getLostItems(),
        builder: (context, lostsSnapshot) {
          if(lostsSnapshot.hasData){
            return FutureBuilder<List>(
              future: getFoundItems(),
              builder: (context, foundsSnapshot){
                if(foundsSnapshot.hasData){
                  List<Widget> lostItems=[];
                  List<Widget> foundItems=[];
                  lostsSnapshot.data!.forEach((element) => {
                    lostItems.add(ListItemWidget(category: "Lost", title: element["title"], description: element["description"],phonenumber: element["phonenumber"] ,location: element["location"], imageURL : element["imageURL"], compressedImageURL: element["compressedImageURL"], date: DateTime.parse(element["date"])))
                  });
                  foundsSnapshot.data!.forEach((element) => {
                    foundItems.add(ListItemWidget(category: "Found", title: element["title"], description: element["description"], location: element["location"], imageURL : element["imageURL"], compressedImageURL: element["compressedImageURL"], date: DateTime.parse(element["date"]),submittedAt: element["submittedat"],))
                  });
                  return StreamBuilder(
                    stream: typeStream,
                    builder: (context, AsyncSnapshot snapshot){
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if(snapshot.hasData && snapshot.data! != "Lost") selectedTypeController.sink.add("Lost");
                                  },
                                  child: ItemTypeBar(text: "Lost", textStyle: MyFonts.medium.size(17).setColor(snapshot.hasData==false ? kBlack : (snapshot.data! == "Lost" ? kBlack : kWhite)),backgroundColor: snapshot.hasData==false ? lBlue2 : (snapshot.data! == "Lost" ? lBlue2 : kBlueGrey),),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    if(!snapshot.hasData) selectedTypeController.sink.add("Found");
                                    if(snapshot.hasData && snapshot.data! != "Found") selectedTypeController.sink.add("Found");
                                  },
                                  child: ItemTypeBar(text: "Found", textStyle: MyFonts.medium.size(17).setColor(snapshot.hasData==false ? kWhite : (snapshot.data! == "Found" ? kBlack : kWhite)),backgroundColor: snapshot.hasData==false ? kBlueGrey : (snapshot.data! == "Found" ? lBlue2 : kBlueGrey),),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: (!snapshot.hasData || snapshot.data! == "Lost") ? (lostItems.length==0 ? Center(child: Text("No Lost Items as of now :)", style: MyFonts.medium.size(16).setColor(kWhite),),) : ListView(children: lostItems,)) :  (foundItems.length==0 ? Center(child: Text("No found Items as of now :)", style: MyFonts.medium.size(16).setColor(kWhite),),) : ListView(children: foundItems,)
                          )
                          )
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
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
        stream: typeStream,
        builder: (context, AsyncSnapshot snapshot){
          return GestureDetector(
            onTap: () async {
              XFile? xFile;
              await showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                        title: Text("From where do you want to take the photo?"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text("Gallery"),
                                onTap: () async {
                                  xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text("Camera"),
                                onTap: () async {
                                  xFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ));
                  });
              if(xFile!=null){
                var bytes = File(xFile!.path).readAsBytesSync();
                var imageSize = (bytes.lengthInBytes/(1048576)); // dividing by 1024*1024
                if(imageSize>2.5){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Maximum image size can be 2.5 MB")));
                  return ;
                }
                var imageString = base64Encode(bytes);
                if(!snapshot.hasData || snapshot.data! =="Lost"){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LostFoundForm(category: "Lost",imageString: imageString,)));
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LostFoundLocationForm(imageString: imageString,)));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 13),
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
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                        Icons.add,
                      size: 24,
                    ),
                  ),
                  Text(
                      !snapshot.hasData ? "Lost Item" : (snapshot.data! =="Lost" ? "Lost Item" : "Found Item"),
                    style: MyFonts.bold.size(15).setColor(kBlack),
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

class ListItemWidget extends StatelessWidget {

  final String category;
  final String title;
  final String location;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final DateTime date;
  final String submittedAt;

  const ListItemWidget({Key? key,required this.category, required this.title, required this.description,required this.location,required this.imageURL,required this.compressedImageURL,required this.date,this.phonenumber = "",this.submittedAt = ""}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Duration passedDuration = DateTime.now().difference(date);
    String timeagoString = timeago.format(DateTime.now().subtract(passedDuration));

    void detailsDialogBox(String category,String imageURL, String description, String location, String contactnumber, String submitted) {
      showDialog(context: context, builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenHeight*0.7),
            child: Container(
              width: screenWidth-40,
              decoration: BoxDecoration(
                  color: kBlueGrey,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4,right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: screenHeight*0.3,maxWidth: screenWidth-40),
                        child: SingleChildScrollView(
                          child: Image.network(imageURL),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                            child: Text(
                              title,
                              style: MyFonts.bold.size(20).setColor(kWhite),
                            ),
                          ),
                          Visibility(
                            visible: category=="Lost" ? true : false,
                            child: GestureDetector(
                              onTap: () async {
                                await launch("tel:+91$contactnumber");
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                  decoration: BoxDecoration(
                                      color: kGrey9,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.phone,size: 20,color: lBlue2,),
                                      Text(
                                        " Call",
                                        style: MyFonts.medium.size(15).setColor(lBlue2),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: category=="Found" ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                        child: Text(
                          "Submitted at: " + submitted,
                          style: MyFonts.medium.size(17).setColor(kGrey6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                      child: Text(
                        (category=="Lost" ? "Lost at: " : "Found at: ") + location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.medium.size(17).setColor(kGrey6),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: screenHeight*0.2,maxWidth: screenWidth-40),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                          child: Text(
                            "Description: " + description,
                            style: MyFonts.light.size(15).setColor(kGrey10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                      alignment: Alignment.centerRight,
                      child: Text(
                        date.day.toString() + "-" + date.month.toString() + "-" + date.year.toString() + " | " + DateFormat.jm().format(date.toLocal()).toString(),
                        style: MyFonts.light.size(13).setColor(kGrey7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }

    return GestureDetector(
      onTap: (){
        detailsDialogBox(category, imageURL, description, location, phonenumber, submittedAt);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 13,vertical: 5),
        decoration: BoxDecoration(
          color: kBlueGrey,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (screenWidth*0.65)-46),
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                          title,
                          maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.medium.size(20).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4,bottom: 6),
                      child: Text(
                          (category=="Lost" ? "Lost " : "Found ") + location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.light.size(17).setColor(kWhite),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13,vertical: 2),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: kGrey9,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                          timeagoString,
                        style: MyFonts.medium.size(14).setColor(lBlue2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 110),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: compressedImageURL,
                  imageBuilder: (context, imageProvider) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                    ),
                  ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    width: screenWidth*0.35,
                    child: Text("Loading...",style: MyFonts.medium.size(14).setColor(kGrey9)),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                ),
                ),
            )
          ],
        ),
      ),
    );
  }
}


class ItemTypeBar extends StatelessWidget {
  final text;
  TextStyle textStyle;
  Color backgroundColor;
  ItemTypeBar({Key? key, required this.text, required this.textStyle,required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,bottom: 10),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20)
      ),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Text(
          text,
        style: textStyle,
      ),
    );
  }
}
