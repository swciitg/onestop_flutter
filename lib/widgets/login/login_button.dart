import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';
import 'package:onestop_kit/onestop_kit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.setLoading,
  });

  final Function setLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kYellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            onPressed: () {
              setLoading();
              // Navigator.of(context).pushNamed(
              //   '/login',
              // );
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Login with Outlook',
                style: MyFonts.w500.factor(2.5).setColor(kBlack),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TextDivider(text: 'OR'),
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Continue as ',
                style: MyFonts.w500.factor(2).setColor(kGrey8),
                children: [
                  TextSpan(
                      text: 'Guest',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final nav = Navigator.of(context);
                          await LoginStore().signInAsGuest();

                          nav.pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        },
                      style: MyFonts.w500.factor(2).setColor(kGrey8).copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold))
                ])),
        Expanded(
          flex: 1,
          child: Container(),
        )
      ],
    );
  }
}
