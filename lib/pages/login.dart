import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/my_spaces.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/powerup.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
        return Scaffold(
          body: loading? const PowerUp():Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg_triangle.png'),
                        fit: BoxFit.fill,
                      )),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 91,
                        child: SafeArea(
                          bottom: false,
                          top: true,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MySpaces.horizontalScreenPadding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text('Welcome to',
                                                style: MyFonts.medium.setColor(kWhite),
                                            ),
                                          ),
                                          Text('your OneStop',
                                              style: MyFonts.medium
                                                  .setColor(kWhite)),
                                          Text('solution for all',
                                              style: MyFonts.medium
                                                  .setColor(kWhite)),
                                          Text('things IITG',
                                              style: MyFonts.medium
                                                  .setColor(kWhite)),
                                        ],
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                      'assets/images/login_illustration.png'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MySpaces.horizontalScreenPadding),
                  child: Column(
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
                            setState(() {
                              loading = true;
                            });
                            context.read<LoginStore>().signInWithMicrosoft(context);
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'LOGIN WITH OUTLOOK',
                              style:
                              MyFonts.medium.factor(3.66).setColor(kBlack),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }


}
