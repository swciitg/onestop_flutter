import 'package:flutter/material.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';


class DataTile extends StatelessWidget {
  final String title;
  final String? semiTitle;
  const DataTile({Key? key, required this.title, this.semiTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (semiTitle != null && semiTitle!.isNotEmpty) {
     
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: MyFonts.w600.size(12).setColor(kTabText),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            semiTitle!,
            style: MyFonts.w500.size(14).setColor(kWhite),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }
      else {return Container();
    }
  }
}
