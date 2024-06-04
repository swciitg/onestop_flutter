import 'dart:convert';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';
import 'package:onestop_dev/stores/login_store.dart';

class AddItemButton extends StatefulWidget {
  const AddItemButton({
    Key? key,
    required this.type,
  }) : super(key: key);

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
                  title:
                      const Text("From where do you want to take the photo?"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        GestureDetector(
                          child: const Text("Gallery"),
                          onTap: () async {
                            xFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          },
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
                        GestureDetector(
                          child: const Text("Camera"),
                          onTap: () async {
                            xFile = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (!mounted) return;
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ));
            });

        if (!mounted) return;
        if (xFile != null) {
          var bytes = File(xFile!.path).readAsBytesSync();
          var imageSize =
              (bytes.lengthInBytes / (1048576)); // dividing by 1024*1024
          if (imageSize > 2.5) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "Maximum image size can be 2.5 MB",
              style: MyFonts.w500,
            )));
            return;
          }
          var imageString = base64Encode(bytes);
          if (widget.type == "Lost") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BuySellForm(
                      category: "Lost",
                      imageString: imageString,
                    )));
            return;
          } else if (widget.type == "Found") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LostFoundLocationForm(
                      imageString: imageString,
                    )));
          } else {
            if (widget.type == "Sell") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuySellForm(
                        category: "Sell",
                        imageString: imageString,
                      )));
              return;
            } else if (widget.type == "Buy") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BuySellForm(
                        category: "Buy",
                        imageString: imageString,
                      )));
              return;
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: lBlue2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                FluentIcons.add_32_filled,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
