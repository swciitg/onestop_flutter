import 'dart:developer';

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
    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // showDialog(context: context, builder: (_) => const TrackingDailog());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MilliTrack()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lBlue2,
                    foregroundColor: kBlueGrey,
                    elevation: 2,
                    shadowColor: lBlue2.withValues(alpha: 0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text("Track Bus", style: MyFonts.w600.size(13).setColor(kBlueGrey)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                TravelDropDown(
                  value: travelStore.busDayType,
                  onChange: travelStore.setBusDayString,
                  items: const ['Weekdays', 'Weekends'],
                ),
              ],
            ),
            BusDetails(index: travelStore.busDayTypeIndex),
          ],
        );
      },
    );
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
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) async {
                log("URL: $url");
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
              (function() {
                  setTimeout(() => {
                    const drawer = document.querySelector('.MuiDrawer-paperAnchorRight');
                    const dock = document.querySelector('.MuiDrawer-paperAnchorDockedLeft');
                    if (dock) {
                      dock.style.display = 'none';
                    }
                    if (drawer) {
                      drawer.style.display = 'none';
                    }
                  }, 2000);
                })();
            ''');
                }

                if (url == 'http://track4.millitrack.com/modern/#/') {
                  // Hide drawer anytime dashboard loads
                  await controller.runJavaScript('''
                (function() {
                  setTimeout(() => {
                    const drawer = document.querySelector('.MuiDrawer-paperAnchorRight');
                    const dock = document.querySelector('.MuiDrawer-paperAnchorDockedLeft');
                    if (dock) {
                      dock.style.display = 'none';
                    }
                    if (drawer) {
                      drawer.style.display = 'none';
                    }
                  }, 2000);
                })();
          ''');
                  log("Done");
                }
              },
            ),
          );
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
              icon: Icon(Icons.open_in_new_rounded, color: OneStopColors.primaryColor),
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
