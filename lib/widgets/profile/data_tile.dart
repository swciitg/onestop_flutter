import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';

class DataTile extends StatelessWidget {
  final String title;
  final String? semiTitle;

  const DataTile({super.key, required this.title, required this.semiTitle});

  @override
  Widget build(BuildContext context) {
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
          semiTitle != null && semiTitle!.isNotEmpty
              ? semiTitle!
              : (LoginStore.isGuest
                  ? "Not set for guest user"
                  : "Not set by you"),
          style: MyFonts.w500.size(14).setColor(kWhite),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
