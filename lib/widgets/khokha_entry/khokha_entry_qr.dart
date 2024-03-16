import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KhokhaEntryQR extends StatelessWidget {
  const KhokhaEntryQR({
    super.key,
    required this.width,
    required this.image,
    required this.destination,
  });

  final double width;
  final QrImageView image;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kAppBarGrey,
      surfaceTintColor: Colors.transparent,
      content: SizedBox(
        width: width * 0.6,
        height: width * 0.6 + 60,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image,
              const SizedBox(height: 16),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Destination: ',
                      style: MyFonts.w500.setColor(kWhite3).size(14),
                    ),
                    TextSpan(
                      text: destination,
                      style: MyFonts.w500.setColor(lBlue2).size(14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}