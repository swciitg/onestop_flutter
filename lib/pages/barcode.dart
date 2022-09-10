import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/globals/size_config.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/appbar.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class QRPage extends StatefulWidget {
  static String id = "/qr";

  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: appBar(context, displayIcon: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
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
                const SizedBox(
                  height: 26,
                ),
                Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: "${context.read<LoginStore>().userData['rollno']}",
                        height: 150,
                        color: kBlack,
                        backgroundColor: kWhite,
                        drawText: false,
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text("Library issuing barcode",textAlign: TextAlign.center,
                      style: MyFonts.w500.setColor(kWhite).size(18),),
                  ),),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginStore>().logOut(() =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/', (Route<dynamic> route) => false));
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
    );
  }
}
