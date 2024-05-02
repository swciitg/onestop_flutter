import 'package:flutter/material.dart';

import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/widgets/developer/social_link.dart';

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
            Text(developerName, style: MyFonts.w500.size(14).setColor(kWhite)),
            const SizedBox(
              height: 5,
            ),
            Text(developerPosition,
                style: MyFonts.w400.size(12).setColor(lBlue)),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialLink(
                    url: 'https://www.linkedin.com/',
                    imagePath: 'assets/images/linkedin.png'),
                SocialLink(
                  url: 'https://github.com/',
                  imagePath: 'assets/images/github.png',
                ),
                SocialLink(
                  url: 'https://outlook.live.com/',
                  imagePath: 'assets/images/outlook.png',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
