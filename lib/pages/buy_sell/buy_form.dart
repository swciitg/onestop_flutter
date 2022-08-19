import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buySell/buy_sell_field.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:provider/provider.dart';

class BuySellForm extends StatefulWidget {
  static const id = "/buySellForm";
  final String category;
  final String imageString;
  final String? submittedat;
  BuySellForm(
      {Key? key,
      required this.category,
      required this.imageString,
      this.submittedat})
      : super(key: key);

  @override
  State<BuySellForm> createState() => _BuySellFormState();
}

class _BuySellFormState extends State<BuySellForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _contactNumber = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _price2 = TextEditingController();
  bool savingToDB = false;
  bool isLoading = false;
  StreamController dbSavingController = StreamController();

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading ? LinearProgressIndicator() : ProgressBar(blue: 2, grey: 0),
              Container(
                margin: EdgeInsets.only(top: 40, left: 15, right: 5, bottom: 15),
                child: Text(
                  widget.category == "Buy"
                      ? "Fill in the details of Requested Item"
                      : "Fill in the details of Selling Item",
                  style: MyFonts.w400.size(16).setColor(kWhite),
                ),
              ),
              InputField(controller: _title, type: 'Title',),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InputField(
                        controller: _price,
                        type: (widget.category == "Buy") ? 'Min Price' : 'Price',
                      )),
                  (widget.category == "Buy")
                      ? Expanded(
                          flex: 1,
                          child: InputField(controller: _price2, type: 'Max Price',)
                  ) : Container(),
                ],
              ),
              InputField(controller: _contactNumber, type: "Contact Number",),
              InputField(controller: _description, type: "Description",),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          bool isValid = formKey.currentState!.validate();
          if (!isValid) {
            return;
          }
          setState(() {isLoading = true;});
          String userEmail = context.read<LoginStore>().userData["email"]!;
          String username = context.read<LoginStore>().userData["name"]!;
          if (savingToDB == true) return;
          savingToDB = true;
          dbSavingController.sink.add(true);
          if (widget.category == "Sell") {
            try {
              print("HERE IN SELL");
              var res = await http.post(
                  Uri.parse("https://swc.iitg.ac.in/onestopapi/sell"),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'title': _title.text.trim(),
                    'description': _description.text.trim(),
                    'imageString': widget.imageString,
                    'email': userEmail,
                    'username': username,
                    'price': _price.text,
                    'phonenumber': _contactNumber.text,
                  }));
              print(res.body);
              var body = jsonDecode(res.body);
              if (body["saved_successfully"] == true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Saved data successfully",
                  style: MyFonts.w500,
                )));
                Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
              } else {
                dbSavingController.sink.add(false);
                savingToDB = false;
                setState(() {isLoading = false;});
                if (body["image_safe"] == false) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "The chosen image is not safe for work !!",
                    style: MyFonts.w500,
                  )));
                  return;
                }
                print(body["error"]);
                setState(() {isLoading = false;});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Some error occured, please try again",
                  style: MyFonts.w500,
                )));
              }
            } catch (e) {
              print(e);
            }
          } else {
            var res = await http.post(
                Uri.parse("https://swc.iitg.ac.in/onestopapi/buy"),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'title': _title.text.trim(),
                  'description': _description.text.trim(),
                  'imageString': widget.imageString,
                  'email': userEmail,
                  'username': username,
                  'price':
                      _price.text.toString() + "-" + _price2.text.toString(),
                  'phonenumber': _contactNumber.text,
                }));
            var body = jsonDecode(res.body);
            if (body["saved_successfully"] == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "Saved data successfully",
                style: MyFonts.w500,
              )));
              Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
            } else {
              dbSavingController.sink.add(false);
              savingToDB = false;
              setState(() {isLoading = false;});
              if (body["image_safe"] == false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "The chosen image is not safe for work !!",
                  style: MyFonts.w500,
                )));
                return;
              }
              setState(() {isLoading = false;});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "Some error occured, please try again",
                style: MyFonts.w500,
              )));
            }
          }
        },
        child: StreamBuilder(
          stream: dbSavingController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return NewPageButton(title: "Saving...");
            }
            return NewPageButton(title: "Submit");
          },
        ),
      ),
    );
  }
}
