import 'package:flutter/material.dart';

import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({
    super.key,
    required this.developerAvatarPath,
    required this.developerName,
    required this.developerPosition,
  });

  final String developerAvatarPath;
  final String developerName;
  final String developerPosition;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(30, 30, 30, 1),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color.fromRGBO(49, 49, 49, 1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(developerAvatarPath),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
                developerName,
                style: MyFonts.w500.size(14).setColor(kWhite)
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
                developerPosition,
                style: MyFonts.w400.size(12).setColor(lBlue)
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/linkedin.png'),
                Image.asset('assets/images/github.png'),
                Image.asset('assets/images/company.png'),
              ],
            )
          ],
        ),
      ),
    );
  }
}