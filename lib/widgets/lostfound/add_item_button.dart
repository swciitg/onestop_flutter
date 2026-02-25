import 'dart:convert';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';

class AddItemButton extends StatefulWidget {
  const AddItemButton({super.key, required this.type});

  final String type;

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  @override
  Widget build(BuildContext context) {
    if (LoginStore().isGuestUser) {
      return Container();
    }
    if (widget.type == "My Ads") {
      return Container();
    }
    return GestureDetector(
      onTap: () async {
        XFile? xFile;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: OColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.m)),
              title: Text(
                "From where do you want to take the photo?",
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                        child: Row(
                          children: [
                            Icon(FluentIcons.image_24_regular, color: OColor.green600),
                            const SizedBox(width: OSpacing.s),
                            Text(
                              "Gallery",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: OSpacing.xs),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: OSpacing.xs),
                        child: Row(
                          children: [
                            Icon(FluentIcons.camera_24_regular, color: OColor.green600),
                            const SizedBox(width: OSpacing.s),
                            Text(
                              "Camera",
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        xFile = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (!mounted) return;
                        Navigator.of(context).pop();
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
          var imageSize = (bytes.lengthInBytes / (1048576)); // dividing by 1024*1024
          if (imageSize > 2.5) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Maximum image size can be 2.5 MB",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                ),
              ),
            );
            return;
          }
          var imageString = base64Encode(bytes);
          if (widget.type == "Lost") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BuySellForm(category: "Lost", imageString: imageString),
              ),
            );
            return;
          } else if (widget.type == "Found") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LostFoundLocationForm(imageString: imageString),
              ),
            );
          } else {
            if (widget.type == "Sell") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BuySellForm(category: "Sell", imageString: imageString),
                ),
              );
              return;
            } else if (widget.type == "Buy") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BuySellForm(category: "Buy", imageString: imageString),
                ),
              );
              return;
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: OColor.green600,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(OSpacing.m),
              child: Icon(FluentIcons.add_32_filled, size: 24, color: OColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
