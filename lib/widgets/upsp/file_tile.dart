import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class FileTile extends StatelessWidget {
  const FileTile({Key? key, required this.filename, required this.onDelete})
      : super(key: key);
  final Function onDelete;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              border: Border.all(color: kGrey2),
              color: kBlueGrey,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    filename,
                    style: MyFonts.w600.size(14).setColor(kWhite),
                  ),
                ),
                GestureDetector(
                  onTap: () => onDelete(),
                  child: const Icon(
                    FluentIcons.dismiss_24_regular,
                    color: kWhite,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
