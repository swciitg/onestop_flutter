import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.setLoading,
  }) : super(key: key);

  final Function setLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kYellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            onPressed: () {
              setLoading();
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'LOGIN WITH OUTLOOK',
                style: MyFonts.w500
                    .factor(3.66)
                    .setColor(kBlack),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
          flex: 1,
        )
      ],
    );
  }
}

