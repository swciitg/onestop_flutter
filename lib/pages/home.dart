import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/myColors.dart';
import 'package:onestop_dev/globals/myFonts.dart';
import 'package:onestop_dev/globals/mySpaces.dart';
import 'package:onestop_dev/globals/sizeConfig.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/widgets/appbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  static String id = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${context.read<LoginStore>().userData['name']}",
                    textAlign: TextAlign.center,
                    style: MyFonts.extraBold,
                  ),
                  Text(
                    '${context.read<LoginStore>().userData['rollno']}',
                    textAlign: TextAlign.center,
                    style: MyFonts.medium,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<LoginStore>().logOut(context);
                      },
                      style: ElevatedButton.styleFrom(elevation:0,primary:lblu),
                      child:  Text('Log Out',style: MyFonts.medium.setColor(kBlue),)),
                  // TODO: QR Embedded image uses Stack. Try using inbuilt embedded image property. Code below
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double parentHeight = constraints.maxHeight;
                        double parentWidth = constraints.maxWidth;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size.square(
                                  0.8 * parentWidth),
                              painter: QrPainter(
                                data:
                                    '${context.read<LoginStore>().userData['name']}\n${context.read<LoginStore>().userData['rollno']}\n${context.read<LoginStore>().userData['email']}',
                                version: 5,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.indigoAccent,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: kBlue,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/iitg_logo.png',
                              height: 0.25 * parentWidth,
                              width: 0.25 * parentWidth,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
* Simple QR Code with embedded image code:
      QrImage(
        data: '${context.read<LoginStore>().userData['name']}',
        version: 5,
        size: 320,
        gapless: true,
        foregroundColor: kBlue,
        embeddedImage: const AssetImage('assets/images/iitg_logo.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(100, 100),
        ),
      )
*/