import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/travel_store.dart';
import 'package:onestop_dev/widgets/travel/bus_details.dart';
import 'package:onestop_dev/widgets/travel/tracking_dailog.dart';
import 'package:onestop_dev/widgets/travel/travel_drop_down.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StopsBusDetails extends StatefulWidget {
  const StopsBusDetails({super.key});

  @override
  State<StopsBusDetails> createState() => _StopsBusDetailsState();
}

class _StopsBusDetailsState extends State<StopsBusDetails> {
  @override
  void initState() {
    super.initState();
    if (DateTime.now().weekday == DateTime.sunday || DateTime.now().weekday == DateTime.saturday) {
      context.read<TravelStore>().setBusDayString("Weekends");
    }
  }

  @override
  Widget build(BuildContext context) {
    var travelStore = context.read<TravelStore>();
    return Observer(builder: (context) {
      return Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  // showDialog(context: context, builder: (_) => const TrackingDailog());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MilliTrack(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  child: Container(
                    height: 32,
                    width: 83,
                    color: lBlue2,
                    child: Center(
                      child: Text(" Track Bus ", style: MyFonts.w500.setColor(kBlueGrey)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              TravelDropDown(
                value: travelStore.busDayType,
                onChange: travelStore.setBusDayString,
                items: const ['Weekdays', 'Weekends'],
              )
            ],
          ),
          BusDetails(index: travelStore.busDayTypeIndex)
        ],
      );
    });
  }
}

class MilliTrack extends StatefulWidget {
  const MilliTrack({super.key});

  @override
  State<MilliTrack> createState() => _MilliTrackState();
}

class _MilliTrackState extends State<MilliTrack> {
  late WebViewController controller;
  final username = "9864028093";
  final password = "123456";

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) async {
          if (url.contains('http://track4.millitrack.com/modern/#/login')) {
            await Future.delayed(Duration(milliseconds: 500));
            await controller.runJavaScript('''
              (function() {
                function setNativeValue(element, value) {
                  const lastValue = element.value;
                  element.value = value;
                  const event = new Event('input', { bubbles: true });
                  event.simulated = true;
                  const tracker = element._valueTracker;
                  if (tracker) {
                    tracker.setValue(lastValue);
                  }
                  element.dispatchEvent(event);
                }

                const inputs = document.querySelectorAll('input');
                if (inputs.length >= 2) {
                  setNativeValue(inputs[0], "$username");
                  setNativeValue(inputs[1], "$password");
                }

                const loginBtn = document.querySelector('button[type="submit"]');
                if (loginBtn) loginBtn.click();
              })();
            ''');
          }
        },
      ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRequest(Uri.parse('http://track4.millitrack.com/modern/#/login'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OneStopColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: OneStopColors.backgroundColor,
        leadingWidth: 100,
        leading: OneStopBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: AppBarTitle(title: "Track Bus"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  useRootNavigator: true,
                  builder: (_) => const TrackingDailog(),
                );
              },
              icon: Icon(
                Icons.open_in_new_rounded,
                color: OneStopColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
