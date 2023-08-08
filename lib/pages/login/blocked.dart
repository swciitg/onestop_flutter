import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class BlockedPage extends StatelessWidget {
  static const String id = "/blocked";
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("YOU HAVE BEEN BLOCKED", style: MyFonts.w500.size(14).setColor(Colors.white),),
            Text("Contact General Secretary, SWC to unblock", style: MyFonts.w500.size(14).setColor(Colors.white),)
          ]
        ),
      ),
    );
  }
}
