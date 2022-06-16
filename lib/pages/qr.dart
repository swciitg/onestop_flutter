import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget {
  static String id = "/qr";

  const QRPage({Key? key}) : super(key: key);

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
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
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "${context.read<LoginStore>().userData['name']}",
                    textAlign: TextAlign.center,
                    style: MyFonts.w800.setColor(kWhite).size(20),
                  ),
                  Text(
                    '${context.read<LoginStore>().userData['rollno']}',
                    textAlign: TextAlign.center,
                    style: MyFonts.w500.setColor(kWhite).size(20),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  // TODO: QR Embedded image uses Stack. Try using inbuilt embedded image property. Code below
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double parentWidth = constraints.maxWidth;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size.square(0.8 * parentWidth),
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<LoginStore>().logOut(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0, primary: kAppBarGrey),
                        child: Text(
                          'Log Out',
                          style: MyFonts.w500.setColor(kBlue),
                        )),
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
