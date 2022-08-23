import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buySell/buy_sell_field.dart';
import 'package:onestop_dev/widgets/lostfound/imp_widgets.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/services/api.dart';

class BuySellForm extends StatefulWidget {
  static const id = "/buySellForm";
  final String category;
  final String imageString;
  final String? submittedAt;
  BuySellForm(
      {Key? key,
      required this.category,
      required this.imageString,
        this.submittedAt})
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
        leading: IconButton(
          onPressed: (){
            if(!isLoading)
              {
                Navigator.of(context).pop();
              }
          },
          icon: Icon(Icons.chevron_left_sharp),
        ),
        backgroundColor: kBlueGrey,
        title: Text(
          widget.category == "Found" ? "3. Details" : "2. Details",
          style: MyFonts.w600.size(16).setColor(kWhite),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? LinearProgressIndicator()
                  : ProgressBar(blue: 2, grey: 0),
              Container(
                margin:
                    EdgeInsets.only(top: 40, left: 15, right: 5, bottom: 15),
                child: Text(
                  "Fill in the details of " + (widget.category == "Buy"
                      ? "Requested Item"
                      : widget.category == "Sell"
                          ? "Selling Item"
                          : widget.category == "Lost"
                              ? "lost object"
                              : "found object"),
                  style: MyFonts.w400.size(16).setColor(kWhite),
                ),
              ),
              InputField(
                controller: _title,
                type: 'Title',
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InputField(
                        controller: _price,
                        type: (widget.category == "Buy")
                            ? 'Min Price'
                            : (widget.category == "Sell")
                                ? 'Price'
                                : (widget.category == "Lost")
                                    ? "Location Lost"
                                    : "Location Found",
                      )),
                  (widget.category == "Buy")
                      ? Expanded(
                          flex: 1,
                          child: InputField(
                            controller: _price2,
                            type: 'Max Price',
                          ))
                      : Container(),
                ],
              ),
              (widget.category != 'Found')
                  ? InputField(
                      controller: _contactNumber,
                      type: "Contact Number",
                    )
                  : Container(),
              InputField(
                controller: _description,
                type: "Description",
              ),
              SizedBox(
                height: 30,
              )
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
          setState(() {
            isLoading = true;
          });


          if (savingToDB == true) return;
          savingToDB = true;
          dbSavingController.sink.add(true);
          var res;
          Map<String, String>data = {};
          data['title'] = _title.text.trim();
          data['submittedAt'] = (widget.submittedAt == null)?"":widget.submittedAt!;
          data['description'] = _description.text.trim();
          data['price'] = _price.text.trim();
          data['location'] = _price.text.trim();
          data['contact'] = _contactNumber.text.trim();
          data['image'] = widget.imageString;
          data['name'] = context.read<LoginStore>().userData["name"]!;
          data['email'] = context.read<LoginStore>().userData["email"]!;
          data['total_price'] = _price.text.toString() + "-" + _price2.text.toString();

          if (widget.category == "Sell") {
            res = await APIService.postSellData(data);
            print(res.body);
          }
          if (widget.category == "Buy") {
            print("Here IN BUY");
            res = await APIService.postBuyData(data);
          }
          if(widget.category=="Lost"){
            res = await APIService.postLostData(data);
            print(res.body);
          }
          if (widget.category == "Found") {
            res = await APIService.postFoundData(data);
          }

          var body = jsonDecode(res.body);
          print(body);
          if (body["saved_successfully"] == true)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Saved data successfully",
                  style: MyFonts.w500,
                )));
            Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
          }
          else
            {
            dbSavingController.sink.add(false);
            savingToDB = false;
            setState(() {
              isLoading = false;
            });
            if (body["image_safe"] == false) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "The chosen image is not safe for work !!",
                    style: MyFonts.w500,
                  )));
              return;
            }
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Some error occured, please try again",
                  style: MyFonts.w500,
                )));
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
