import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/pick_file.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({Key? key, required this.callBack}) : super(key: key);
  final Function callBack;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploading
          ? null
          : () async {
              String? fileName = await uploadFile(
                  context,
                  () => setState(() {
                        uploading = true;
                      }));
              widget.callBack(fileName);
              setState(() {
                uploading = false;
              });
            },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                border: Border.all(color: kGrey2),
                color: kBackground,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Upload",
                      style: MyFonts.w600.size(14).setColor(kWhite),
                    ),
                  ),
                  uploading
                      ? const CircularProgressIndicator(
                          color: lBlue2,
                        )
                      : const Icon(
                          FluentIcons.arrow_upload_16_regular,
                          color: kWhite,
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
