import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
// TODO: Make profile picture clickable and redirect to QR
AppBar appBar(BuildContext context, {bool displayIcon = true}) {
  return AppBar(
    backgroundColor: bg2,
    iconTheme: IconThemeData(color: lblu),
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        displayIcon?CircleAvatar(
          child: IconButton(
            icon: const Icon(Icons.account_circle_outlined,color:kBlue,),
            onPressed: (){
              Navigator.pushNamed(context, "/home");
            },
          ),
          backgroundColor: lblu,
        ):CircleAvatar(
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,color: kBlue),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: lblu,
        ),
        RichText(
          text: TextSpan(
              text: 'One',
              style: MyFonts.extraBold.factor(4.39).letterSpace(1.0).setColor(kBlue),
              children: [
                TextSpan(
                  text: '.',
                  style: MyFonts.extraBold.factor(5.85).setColor(kYellow),
                )
              ]),
        ),
        CircleAvatar(backgroundColor:lblu,child: IconButton(onPressed: (){}, icon: Icon(Icons.notifications_outlined),color: kBlue,)),
      ],
    ),
    elevation: 0.0,
  );
}