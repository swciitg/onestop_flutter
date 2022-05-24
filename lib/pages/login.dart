import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/my_spaces.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/powerup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  static String id = "/login";

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: loading
          ? WebView(
        initialUrl: "https://swc.iitg.ac.in/onestopapi/auth/microsoft",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller){
          _controller.complete(controller);
        },
        onPageFinished: (url) async {
          if(url.startsWith("https://swc.iitg.ac.in/onestopapi/auth/microsoft/redirect?code")){
            WebViewController controller = await _controller.future;
            var userInfoString = await controller.runJavascriptReturningResult("document.getElementById('userInfo').innerText");
            print(userInfoString);
            var userInfo = {};
            String check = "";
            int count=1;
            for(int i=0;i<userInfoString.length;i++){
              if(userInfoString[i]!="/"){
                check = check + userInfoString[i];
              }
              else{
                print(check);
                if(count==1){
                  userInfo["displayName"] = check;
                }
                else if(count==2){
                  userInfo["mail"] = check;
                }
                else{
                  userInfo["surname"] = check;
                }
                check="";
                count+=1;
              }
            }
            print(check);
            userInfo["id"]=check;
            SharedPreferences user = await SharedPreferences.getInstance();
            // {"displayName" : "Kunal Pal","mail" : "k.pal@iitg.ac.in","surname": "200104048","id" : "jdkf"}
            context
                .read<LoginStore>()
                .saveToPreferences(user, userInfo);
            context
                .read<LoginStore>()
                .saveToUserData(user);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        },
      )
          : Column(
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
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                'Welcome to',
                                                style: MyFonts.medium
                                                    .setColor(kWhite),
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
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'LOGIN WITH OUTLOOK',
                                style: MyFonts.medium
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
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
