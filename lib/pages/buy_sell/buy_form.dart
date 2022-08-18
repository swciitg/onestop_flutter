import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:provider/provider.dart';
class BuySellForm extends StatefulWidget {
  static const id = "/buySellForm";
  final String category;
  final String imageString;
  final String? submittedat;
  BuySellForm({Key? key,required this.category,required this.imageString,this.submittedat}) : super(key: key);

  @override
  State<BuySellForm> createState() => _BuySellFormState();
}

class _BuySellFormState extends State<BuySellForm> {

  final formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? location="Random";
  String? contactnumber;
  bool savingToDB = false;
  StreamController dbSavingController = StreamController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
          "2. Details",
          style: MyFonts.w600.size(16).setColor(kWhite),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressBar(blue: 2, grey: 0),
                Container(
                  margin: EdgeInsets.only(top: 40,left: 15,right: 5,bottom: 15),
                  child: Text(
                    widget.category=="Buy" ? "Fill in the details of Buying Item" : "Fill in the details of Selling Item",
                    style: MyFonts.w400.size(16).setColor(kWhite),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: TextFormField(
                    style: MyFonts.w500.size(15).setColor(kWhite),
                    decoration: InputDecoration(
                        hintText: "Title*",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: kAppBarGrey,
                        filled: true,
                        hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        counterText: (title==null ? "" : title!.length.toString() + "/20"),
                        counterStyle: MyFonts.w500.size(12).setColor(kWhite)
                    ),
                    maxLength: 20,
                    onChanged: (value){
                      setState((){
                        title=value;
                      });
                    },
                    validator: (value){
                      if(value==null || value=="") return "This field cannot be null";
                      return null;
                    },
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                //   child: TextFormField(
                //     style: MyFonts.w500.size(15).setColor(kWhite),
                //     decoration: InputDecoration(
                //         hintText: widget.category=="Lost" ? "Location Lost*" : "Location Found*",
                //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                //         fillColor: kAppBarGrey,
                //         filled: true,
                //         hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                //         counterText: (location==null ? "" : location!.length.toString() + "/20"),
                //         counterStyle: MyFonts.w500.size(12).setColor(kWhite)
                //     ),
                //     onChanged: (value){
                //       setState((){
                //         location=value;
                //       });
                //     },
                //     maxLength: 20,
                //     validator: (value){
                //       if(value==null || value=="") return "This field cannot be null";
                //     },
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: TextFormField(
                    style: MyFonts.w500.size(15).setColor(kWhite),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                        hintText: "Contact Number*",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: kAppBarGrey,
                        filled: true,
                        hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        counterText: (contactnumber==null ? "" : contactnumber!.length.toString() + "/10"),
                        counterStyle: MyFonts.w500.size(12).setColor(kWhite)
                    ),
                    onChanged: (value){
                      setState((){
                        contactnumber=value;
                      });
                    },
                    validator: (value){
                      if(value==null || value=="") return "This field cannot be null";
                      if(value.trim().length!=10) return "The contact should have 10 digits";
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: TextFormField(
                    style: MyFonts.w500.size(15).setColor(kWhite),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Description*",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: kAppBarGrey,
                        filled: true,
                        hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        counterText: (description==null ? "" : description!.length.toString() + "/100"),
                        counterStyle: MyFonts.w500.size(12).setColor(kWhite)
                    ),
                    maxLength: 100,
                    maxLines: 10,
                    onChanged: (value){
                      setState((){
                        description=value;
                      });
                    },
                    validator: (value){
                      if(value==null || value=="") return "This field cannot be null";
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          bool isValid = formKey.currentState!.validate();
          if(!isValid){
            return;
          }
          // SharedPreferences user = await SharedPreferences.getInstance();
          // String userEmail = await user.getString("email")!;
          // String username = await user.getString("name")!;
          String userEmail = context.read<LoginStore>().userData["email"]!;
          String username = context.read<LoginStore>().userData["name"]!;
          if(savingToDB==true) return;
          savingToDB=true;
          dbSavingController.sink.add(true);
          print(userEmail);
          print(username);
          print(location);
          print(widget.imageString);
          print(contactnumber);
          print(description);
          if(widget.category=="Sell"){
            print("HERE");
            var res = await http.post(
                Uri.parse("https://swc.iitg.ac.in/onestopapi/sell"),
                body: jsonEncode({
                  'title': title!.trim(),
                  'description' : description!.trim(),
                  'location' : location!.trim(),
                  'imageString' : widget.imageString,
                  'phonenumber' : contactnumber!.trim(),
                  'email' : userEmail,
                  'username' : username
                })
            );
            print(res.body);
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully", style: MyFonts.w500,)));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              dbSavingController.sink.add(false);
              savingToDB=false;
              if(body["image_safe"]==false){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The chosen image is not safe for work !!", style: MyFonts.w500,)));
                return;
              }
              print(body["error"]);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again", style: MyFonts.w500,)));
            }
          }
          else{
            var res = await http.post(
                Uri.parse("https://swc.iitg.ac.in/onestopapi/buy"),
                body: jsonEncode({
                  'title': title!.trim(),
                  'description' : description!.trim(),
                  'location' : location!.trim(),
                  'imageString' : widget.imageString,
                  'submittedat' : widget.submittedat!,
                  'email' : userEmail,
                  'username' : username
                })
            );
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully", style: MyFonts.w500,)));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              dbSavingController.sink.add(false);
              savingToDB=false;
              if(body["image_safe"]==false){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The chosen image is not safe for work !!", style: MyFonts.w500,)));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again", style: MyFonts.w500,)));
            }
          }
        },
        child: StreamBuilder(
          stream: dbSavingController.stream,
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData && snapshot.data == true){
              return NewPageButton(title: "Saving...");
            }
            return NewPageButton(title: "Submit");
          },
        ),
      ),
    );
  }
}