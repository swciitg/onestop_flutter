import 'package:flutter/material.dart';

import '../../../globals/my_colors.dart';
import '../../../globals/my_fonts.dart';

Future<void> reload(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Error',
                  style: MyFonts.bold.size(24).setColor(kWhite),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'You\'ve run into the error,please reload.',
                  style: MyFonts.regular.size(14).setColor(Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(85, 95, 113, 100)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Replay.png',
                        height: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Reload',
                        style: MyFonts.medium.size(14).setColor(Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}

