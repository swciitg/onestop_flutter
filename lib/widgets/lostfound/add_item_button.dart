import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/pages/lost_found/found_location_selection.dart';

class AddItemButton extends StatefulWidget {
  const AddItemButton({
    Key? key,
    required this.typeStream,
    required this.initialData,
  }) : super(key: key);

  final Stream typeStream;
  final String initialData;

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.typeStream,
      initialData: widget.initialData,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == "My Ads") {
          return Container();
        }
        return GestureDetector(
          onTap: () async {
            XFile? xFile;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(
                          "From where do you want to take the photo?"),
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
              if (widget.initialData == "Lost") {
                if (snapshot.data == "Lost") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuySellForm(
                            category: "Lost",
                            imageString: imageString,
                          )));
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LostFoundLocationForm(
                          imageString: imageString,
                        )));
              } else {
                if (snapshot.data == "Sell") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuySellForm(
                            category: "Sell",
                            imageString: imageString,
                          )));
                  return;
                } else if (snapshot.data == "Buy") {
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 17, bottom: 20, left: 20),
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 16, right: 20, bottom: 18),
                  child: Text(
                    "${snapshot.data} Item",
                    style: MyFonts.w600.size(14).setColor(kBlack),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
