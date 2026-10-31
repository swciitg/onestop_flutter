import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/services/moderation_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_sell_field.dart';
import 'package:onestop_ui/index.dart';

class BuySellForm extends StatefulWidget {
  static const id = "/buySellForm";
  final String category;
  final String? imageString;
  final String? submittedAt;

  const BuySellForm({
    super.key,
    required this.category,
    this.imageString,
    this.submittedAt,
  });

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

  /// Current step: 1 = Upload Photo, 2 = Add Details
  int _currentStep = 1;

  /// Collected image as base64
  String? _imageString;

  @override
  void initState() {
    super.initState();
    _imageString = widget.imageString;
    // If image was already provided (e.g. from Lost/Found flow), skip to step 2
    if (_imageString != null) {
      _currentStep = 2;
    }
  }

  String get _pageTitle {
    switch (widget.category) {
      case "Sell":
        return "Sell an item";
      case "Buy":
        return "Request an item";
      case "Lost":
        return "Report lost item";
      case "Found":
        return "Report found item";
      default:
        return "Details";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (!isLoading) {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
        ),
        title: Text(
          _pageTitle,
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          if (!isLoading)
            _buildStepIndicator()
          else
            LinearProgressIndicator(color: OColor.green600),

          Divider(height: 1, color: OColor.gray200),

          // Content
          Expanded(child: _currentStep == 1 ? _buildStep1() : _buildStep2()),
        ],
      ),
      bottomNavigationBar:
          _currentStep == 1 ? _buildStep1Buttons() : _buildStep2Buttons(),
    );
  }

  /// Step indicator with numbered circles and connecting line
  Widget _buildStepIndicator() {
    final bool step1Done = _currentStep > 1;
    final bool step2Active = _currentStep == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: OSpacing.s),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                _StepCircle(
                  number: 1,
                  isActive: _currentStep == 1,
                  isCompleted: step1Done,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: OSpacing.xs),
                    color: step1Done ? OColor.green600 : OColor.gray200,
                  ),
                ),
                _StepCircle(
                  number: 2,
                  isActive: step2Active,
                  isCompleted: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UPLOAD PHOTO',
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray800,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'ADD DETAILS',
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray800,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Step 1: Upload Photo
  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(OSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: OSpacing.m),
            Text(
              'Upload a photo of the product',
              style: OTextStyle.labelMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: OSpacing.xxs),
            Text(
              'You can upload 1 photo of the product',
              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
            ),
            const SizedBox(height: OSpacing.m),

            // Image preview if selected
            if (_imageString != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(OCornerRadius.m),
                child: Image.memory(
                  base64Decode(_imageString!),
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: OSpacing.s),
              // Change photo button
              GestureDetector(
                onTap: () => _pickImage(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                  decoration: BoxDecoration(
                    border: Border.all(color: OColor.gray300),
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.edit_24_regular,
                        size: 16,
                        color: OColor.green600,
                      ),
                      const SizedBox(width: OSpacing.xxs),
                      Text(
                        'Change Photo',
                        style: OTextStyle.labelSmall.copyWith(
                          color: OColor.green600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Add photo button
              GestureDetector(
                onTap: () => _pickImage(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                  decoration: BoxDecoration(
                    border: Border.all(color: OColor.gray300),
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.add_24_regular,
                        size: 16,
                        color: OColor.green600,
                      ),
                      const SizedBox(width: OSpacing.xxs),
                      Text(
                        'Add Photo',
                        style: OTextStyle.labelSmall.copyWith(
                          color: OColor.green600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Step 2: Enter Details (existing form)
  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: OSpacing.l),

            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Details',
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray800,
                    ),
                  ),
                  const SizedBox(height: OSpacing.xs),
                  Text(
                    'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: OSpacing.l),

            // Form fields
            InputField(
              controller: _title,
              type: widget.category == "Sell" ? 'Product Name' : 'Title',
              hintText: 'Dryer, Mouse, Table Fan, etc.',
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InputField(
                    controller: _price,
                    type:
                        (widget.category == "Buy")
                            ? 'Min Price'
                            : (widget.category == "Sell")
                            ? 'Product Price'
                            : (widget.category == "Lost")
                            ? "Location Lost"
                            : "Location Found",
                    hintText: widget.category == "Sell" ? 'e.g. 100' : null,
                  ),
                ),
                (widget.category == "Buy")
                    ? Expanded(
                      flex: 1,
                      child: InputField(controller: _price2, type: 'Max Price'),
                    )
                    : const SizedBox.shrink(),
              ],
            ),
            (widget.category != 'Found')
                ? InputField(controller: _contactNumber, type: "Contact Number")
                : const SizedBox.shrink(),
            InputField(
              controller: _description,
              type: "Description",
              hintText:
                  'Add a brief description, original price, condition, and any other details about your item.',
            ),
            const SizedBox(height: OSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// Step 1 bottom buttons: Cancel + Next
  Widget _buildStep1Buttons() {
    final bool hasImage = _imageString != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.m,
        OSpacing.m,
        OSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: OColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: OSpacing.m),
                decoration: BoxDecoration(
                  border: Border.all(color: OColor.gray300),
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, size: 24, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text(
                      'Cancel',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.green600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          // Next button
          Expanded(
            child: GestureDetector(
              onTap:
                  hasImage
                      ? () {
                        if (widget.category == "Found") {
                          // Found items need location selection before details
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (_) => LostFoundLocationForm(
                                    imageString: _imageString!,
                                  ),
                            ),
                          );
                        } else {
                          setState(() {
                            _currentStep = 2;
                          });
                        }
                      }
                      : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: OSpacing.m),
                decoration: BoxDecoration(
                  color: hasImage ? OColor.green600 : OColor.green200,
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.white,
                      ),
                    ),
                    const SizedBox(width: OSpacing.xxs),
                    Icon(
                      FluentIcons.arrow_right_24_regular,
                      size: 24,
                      color: OColor.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2 bottom buttons: Back + Post
  Widget _buildStep2Buttons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        OSpacing.m,
        OSpacing.s,
        OSpacing.m,
        OSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: OColor.white,
        border: Border(top: BorderSide(color: OColor.gray200)),
      ),
      child: Row(
        children: [
          // Back button
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLoading) {
                  setState(() {
                    _currentStep = 1;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: BorderRadius.circular(OCornerRadius.m),
                  border: Border.all(color: OColor.gray200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.arrow_left_24_regular,
                      size: 18,
                      color: OColor.gray800,
                    ),
                    const SizedBox(width: OSpacing.xs),
                    Text(
                      'Back',
                      style: OTextStyle.labelMedium.copyWith(
                        color: OColor.gray800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: OSpacing.s),
          // Post button
          Expanded(
            flex: 2,
            child: StreamBuilder(
              stream: dbSavingController.stream,
              builder: (context, AsyncSnapshot snapshot) {
                final isSaving = snapshot.hasData && snapshot.data == true;
                return GestureDetector(
                  onTap: isSaving ? null : _handleSubmit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
                    decoration: BoxDecoration(
                      color: OColor.green600,
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSaving ? 'Saving...' : 'Post',
                          style: OTextStyle.labelMedium.copyWith(
                            color: OColor.white,
                          ),
                        ),
                        if (!isSaving) ...[
                          const SizedBox(width: OSpacing.xs),
                          Icon(
                            FluentIcons.checkmark_24_regular,
                            size: 18,
                            color: OColor.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (widget.category == "Buy") {
      if ((int.parse(_price2.text) - int.parse(_price.text)) < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Min price should be smaller than max price",
              style: OTextStyle.bodySmall.copyWith(color: OColor.white),
            ),
          ),
        );
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
    data['submittedAt'] =
        (widget.submittedAt == null) ? "" : widget.submittedAt!;
    data['description'] = _description.text.trim();
    data['price'] = _price.text.trim();
    data['location'] = _price.text.trim();
    data['contact'] = _contactNumber.text.trim();
    data['image'] = _imageString ?? '';
    data['name'] = LoginStore.userData["name"]!;
    data['email'] = LoginStore.userData["outlookEmail"]!;
    data['total_price'] = "${_price.text}-${_price2.text}";

    try {
      final isTitleValid = await ModerationService().validateBuyOrSell(
        _title.text.trim(),
      );
      if (!isTitleValid) {
        Fluttertoast.showToast(
          msg: 'Please Enter an appropriate title!',
          backgroundColor: OColor.gray800,
        );
        _resetSaving();
        return;
      }

      final isDescValid = await ModerationService().validateBuyOrSell(
        _description.text.trim(),
      );
      if (!isDescValid) {
        Fluttertoast.showToast(
          msg: 'Please Enter an appropriate description!',
          backgroundColor: OColor.gray800,
        );
        _resetSaving();
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
    } catch (e) {
      // Error snackbar shown below
    }

    var responseBody = res;

    if (!mounted) return;
    if (responseBody["saved_successfully"] == true) {
      Fluttertoast.showToast(
        msg: "Request posted successfully!",
        backgroundColor: OColor.green600,
      );
      if (navigatorKey.currentState != null) {
        Navigator.popUntil(
          navigatorKey.currentContext!,
          ModalRoute.withName(HomePage.id),
        );
      }
    } else {
      _resetSaving();
      if (responseBody["image_safe"] == false) {
        Fluttertoast.showToast(
          msg: "The chosen image is NSFW!",
          backgroundColor: OColor.red500,
        );
        return;
      }
      Fluttertoast.showToast(
        msg: "Some error occurred! Please try again.",
        backgroundColor: OColor.gray800,
      );
    }
  }

  void _resetSaving() {
    dbSavingController.sink.add(false);
    savingToDB = false;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    XFile? xFile;
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: OColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          title: Text(
            'From where do you want to take the photo?',
            style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          FluentIcons.image_24_regular,
                          color: OColor.green600,
                        ),
                        const SizedBox(width: OSpacing.s),
                        Text(
                          'Gallery',
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    xFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: OSpacing.xs),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          FluentIcons.camera_24_regular,
                          color: OColor.green600,
                        ),
                        const SizedBox(width: OSpacing.s),
                        Text(
                          'Camera',
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    xFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (xFile != null) {
      var bytes = File(xFile!.path).readAsBytesSync();
      var imageSize = bytes.lengthInBytes / 1048576;
      if (imageSize > 2.5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Maximum image size can be 2.5 MB',
              style: OTextStyle.bodySmall.copyWith(color: OColor.white),
            ),
          ),
        );
        return;
      }
      setState(() {
        _imageString = base64Encode(bytes);
      });
    }
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.isActive,
    required this.isCompleted,
  });

  final int number;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Widget child;

    if (isCompleted) {
      bgColor = OColor.green600;
      child = Icon(Icons.check, size: 18, color: OColor.white);
    } else if (isActive) {
      bgColor = OColor.green600;
      child = Text(
        '$number',
        style: OTextStyle.labelSmall.copyWith(
          color: OColor.white,
          fontSize: 16,
        ),
      );
    } else {
      bgColor = OColor.gray200;
      child = Text(
        '$number',
        style: OTextStyle.labelSmall.copyWith(
          color: OColor.gray800,
          fontSize: 16,
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
