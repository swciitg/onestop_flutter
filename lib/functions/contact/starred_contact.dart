import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

starredContact(String contact)
{
  int size = contact.length;
  return TextButton(
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      child: Container(
        height: 32,
        width: 10*size+25,
        color: kGrey9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contact,
              style: MyFonts.w400.setColor(kWhite),
            ),
          ],
        ),
      ),
    ), onPressed: (){},);
}
