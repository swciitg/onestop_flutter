import 'dart:async';
import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/services/moderation_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_sell_field.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_kit/onestop_kit.dart';

class BuySellForm extends StatefulWidget {
  static const id = "/buySellForm";
  final String category;
  final String imageString;
  final String? submittedAt;

  const BuySellForm(
      {super.key, required this.category, required this.imageString, this.submittedAt});

  @override
  State<BuySellForm> createState() => _BuySellFormState();
}

class _BuySellFormState extends State<BuySellForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _price2 = TextEditingController();
  bool savingToDB = false;
  bool isLoading = false;
  StreamController dbSavingController = StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (!isLoading) {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(
            FluentIcons.chevron_left_24_regular,
          ),
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
                  ? const LinearProgressIndicator()
                  : widget.category == "Found"
                      ? const ProgressBar(blue: 3, grey: 0)
                      : const ProgressBar(blue: 2, grey: 0),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 15, right: 5, bottom: 15),
                child: Text(
                  "Fill in the details of ${widget.category == "Buy" ? "Requested Item" : widget.category == "Sell" ? "Selling Item" : widget.category == "Lost" ? "lost object" : "found object"}",
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
              const SizedBox(
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
          if (widget.category == "Buy") {
            if ((int.parse(_price2.text) - int.parse(_price.text)) < 0) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                "Min price should be smaller than max price",
                style: MyFonts.w500,
              )));
              return;
            }
          }
          setState(() {
            isLoading = true;
          });

          if (savingToDB == true) return;
          savingToDB = true;
          dbSavingController.sink.add(true);
          var res = {};
          Map<String, String> data = {};
          data['title'] = _title.text.trim();
          data['submittedAt'] = (widget.submittedAt == null) ? "" : widget.submittedAt!;
          data['description'] = _description.text.trim();
          data['price'] = _price.text.trim();
          data['location'] = _price.text.trim();
          data['contact'] = _contactNumber.text.trim();
          data['image'] = widget.imageString;
          data['name'] = LoginStore.userData["name"]!;
          data['email'] = LoginStore.userData["outlookEmail"]!;
          data['total_price'] = "${_price.text}-${_price2.text}";

          try {
            final isTitleValid = await ModerationService().validateBuyOrSell(_title.text.trim());
            if (!isTitleValid) {
              Fluttertoast.showToast(
                  msg: 'Please Enter an appropriate title!',
                  backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7));
              dbSavingController.sink.add(false);
              savingToDB = false;
              setState(() {
                isLoading = false;
              });
              return;
            }

            final isDescValid =
                await ModerationService().validateBuyOrSell(_description.text.trim());
            if (!isDescValid) {
              Fluttertoast.showToast(
                  msg: 'Please Enter an appropriate description!',
                  backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7));
              dbSavingController.sink.add(false);
              savingToDB = false;
              setState(() {
                isLoading = false;
              });
              return;
            }
          } catch (e) {
            log("ERROR validating BuyOrSell details");
          }

          try {
            if (widget.category == "Sell") {
              res = await BnsRepository().postSellData(data);
            }
            if (widget.category == "Buy") {
              res = await BnsRepository().postBuyData(data);
            }
            if (widget.category == "Lost") {
              res = await LnfRepository().postLostData(data);
            }
            if (widget.category == "Found") {
              res = await LnfRepository().postFoundData(data);
            }
            // ignore: empty_catches
          } catch (e) {
            // Error snackbar shown below
          }

          var responseBody = res;

          if (!mounted) return;
          if (responseBody["saved_successfully"] == true) {
            Fluttertoast.showToast(
              msg: "Request posted successfully!",
              backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
            );
            Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
          } else {
            dbSavingController.sink.add(false);
            savingToDB = false;
            setState(() {
              isLoading = false;
            });
            if (responseBody["image_safe"] == false) {
              Fluttertoast.showToast(
                msg: "The chosen image is NSFW!",
                backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
              );
              return;
            }
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
              msg: "Some error occurred! Please try again.",
              backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
            );
          }
        },
        child: StreamBuilder(
          stream: dbSavingController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return const NextButton(title: "Saving...");
            }
            return const NextButton(title: "Submit");
          },
        ),
      ),
    );
  }
}
