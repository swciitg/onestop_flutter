import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
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
  StreamController dbSavingController = StreamController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kBlueGrey,
        title: Text(
            widget.category=="Lost" ? "2. Details" : "3. Details",
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
                ProgressBar(blue: widget.category=="Lost" ? 2 : 3, grey: 0),
                Container(
                  margin: EdgeInsets.only(top: 40,left: 15,right: 5,bottom: 15),
                  child: Text(
                    widget.category=="Lost" ? "Fill in the details of lost object" : "Fill in the details of found object",
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
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: TextFormField(
                    style: MyFonts.w500.size(15).setColor(kWhite),
                    decoration: InputDecoration(
                        hintText: widget.category=="Lost" ? "Location Lost*" : "Location Found*",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        fillColor: kAppBarGrey,
                        filled: true,
                        hintStyle: MyFonts.w500.size(15).setColor(kGrey10),
                        counterText: (location==null ? "" : location!.length.toString() + "/20"),
                      counterStyle: MyFonts.w500.size(12).setColor(kWhite)
                    ),
                    onChanged: (value){
                     setState((){
                       location=value;
                     });
                    },
                    maxLength: 20,
                    validator: (value){
                      if(value==null || value=="") return "This field cannot be null";
                    },
                  ),
                ),
                Visibility(
                  visible: widget.category=="Lost" ? true : false,
                  child: Container(
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
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: TextFormField(
                    style: MyFonts.w500.size(15).setColor(kWhite),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Description",
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
          if(widget.category=="Lost"){
            var res = await http.post(
                Uri.parse("https://swc.iitg.ac.in/onestopapi/post_lost"),
              body: {
                'title': title!.trim(),
                'description' : description!.trim(),
                'location' : location!.trim(),
                'imageString' : widget.imageString,
                'phonenumber' : contactnumber!.trim(),
                'email' : userEmail,
                'username' : username
              }
            );
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully")));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              dbSavingController.sink.add(false);
              savingToDB=false;
              if(body["image_safe"]==false){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The chosen image is not safe for work !!")));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again")));
            }
          }
          else{
            var res = await http.post(
                Uri.parse("https://swc.iitg.ac.in/onestopapi/post_found"),
                body: {
                  'title': title!,
                  'description' : description!,
                  'location' : location!,
                  'imageString' : widget.imageString,
                  'submittedat' : widget.submittedat!,
                  'email' : userEmail,
                  'username' : username
                }
            );
            var body = jsonDecode(res.body);
            if(body["saved_successfully"]==true){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved data successfully")));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            }
            else{
              dbSavingController.sink.add(false);
              savingToDB=false;
              if(body["image_safe"]==false){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The chosen image is not safe for work !!")));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Some error occured, please try again")));
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
