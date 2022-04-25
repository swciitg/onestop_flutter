import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home.dart';
import 'package:onestop_dev/pages/lost_found/imp_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
class LostFoundForm extends StatefulWidget {
  static const id = "/lostFoundForm";
  final String category;
  final String imageString;
  String? submittedat;
  LostFoundForm({Key? key,required this.category,required this.imageString,this.submittedat}) : super(key: key);

  @override
  State<LostFoundForm> createState() => _LostFoundFormState();
}

class _LostFoundFormState extends State<LostFoundForm> {

  final formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? location;
  String? contactnumber;
  bool savingToDB = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
            widget.category=="Lost" ? "2. Details" : "3. Details",
          style: MyFonts.medium.size(20).setColor(kWhite),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(blue: widget.category=="Lost" ? 2 : 3, grey: 0),
            Container(
              margin: EdgeInsets.only(top: 40,left: 5,right: 5,bottom: 15),
              child: Text(
                widget.category=="Lost" ? "Fill in the details" : "Fill in the details of found object",
                style: MyFonts.medium.size(16).setColor(kWhite),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: TextFormField(
                style: MyFonts.medium.size(15).setColor(kWhite),
                decoration: InputDecoration(
                  hintText: "Title*",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: kGrey2,
                  filled: true,
                  hintStyle: MyFonts.medium.size(15).setColor(kWhite)
                ),
                onChanged: (value){
                  title=value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: TextFormField(
                style: MyFonts.medium.size(15).setColor(kWhite),
                decoration: InputDecoration(
                    hintText: widget.category=="Lost" ? "Location Lost*" : "Location Found*",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    fillColor: kGrey2,
                    filled: true,
                    hintStyle: MyFonts.medium.size(15).setColor(kWhite)
                ),
                onChanged: (value){
                 location=value;
                },
              ),
            ),
            Visibility(
              visible: widget.category=="Lost" ? true : false,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                child: TextFormField(
                  style: MyFonts.medium.size(15).setColor(kWhite),
                  decoration: InputDecoration(
                      hintText: "Contact Number*",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      fillColor: kGrey2,
                      filled: true,
                      hintStyle: MyFonts.medium.size(15).setColor(kWhite)
                  ),
                  onChanged: (value){
                    contactnumber=value;
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: TextFormField(
                style: MyFonts.medium.size(15).setColor(kWhite),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    fillColor: kGrey2,
                    filled: true,
                    hintStyle: MyFonts.medium.size(15).setColor(kWhite),
                ),
                maxLines: 6,
                onChanged: (value){
                  description=value;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          if(savingToDB==true) return;
          savingToDB=true;
          if(widget.category=="Lost"){
            var res = await http.post(
              Uri.parse('https://one-stop-api.herokuapp.com/raisepost'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'title': title!,
                'description' : description!,
                'location' : location!,
                'link' : widget.imageString,
                'phonenumber' : contactnumber!,
              }),
            );
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully")));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              savingToDB=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again")));
            }
          }
          else{
            var res = await http.post(
              Uri.parse('https://one-stop-api.herokuapp.com/foundpost'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'title': title!,
                'description' : description!,
                'location' : location!,
                'link' : widget.imageString,
                'submittedat' : widget.submittedat!
              }),
            );
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully")));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              savingToDB=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again")));
            }
          }
        },
        child: NewPageButton(title: "Submit",),
      ),
    );
  }
}
