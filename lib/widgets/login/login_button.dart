import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/text_divider.dart';

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
                'LOGIN WITH OUTLOOK',
                style: MyFonts.w500.factor(3.2).setColor(kBlack),
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
                          await LoginStore().signInAsGuest();
                          // TODO: Next version of Flutter will have context.mounted. Use that instead to escape the lint
                          Navigator.of(context).pushNamedAndRemoveUntil(
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
