import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class UPSPDialog extends StatelessWidget {
  const UPSPDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogTheme(
          backgroundColor: kBackground,
          titleTextStyle: MyFonts.w600.setColor(lBlue).size(20),
          contentTextStyle: MyFonts.w400.setColor(lBlue),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: lBlue2, textStyle: MyFonts.w600),
        ),
      ),
      child: AlertDialog(
        title: const Text('Select the type of file'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(FileType.media);
              },
              child: const Row(
                children: [
                  Icon(FluentIcons.image_16_regular),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Image/Video')
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(FileType.custom);
              },
              child: const Row(
                children: [
                  Icon(FluentIcons.document_pdf_16_regular),
                  SizedBox(
                    width: 10,
                  ),
                  Text('PDF')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
