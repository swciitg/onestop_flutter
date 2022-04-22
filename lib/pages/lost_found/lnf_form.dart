import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/lost_found/imp_widgets.dart';
class LostFoundForm extends StatefulWidget {
  static const id = "/lostFoundForm";
  final String category;
  String? imageString;
  LostFoundForm({Key? key,required this.category,this.imageString}) : super(key: key);

  @override
  State<LostFoundForm> createState() => _LostFoundFormState();
}

class _LostFoundFormState extends State<LostFoundForm> {

  final formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? location;
  String? contactnumber;

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
        onTap: (){
          print("Submitted");
        },
        child: NewPageButton(title: "Submit",),
      ),
    );
  }
}
