import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart'; 
import 'package:onestop_dev/widgets/medicalsection/medical_date_slider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalTimetable extends StatefulWidget {
  const MedicalTimetable({Key? key}) : super(key: key);

  @override
  State<MedicalTimetable> createState() => _MedicalTimetableState();
}

class _MedicalTimetableState extends State<MedicalTimetable> {
  // List<Map<int, List<List<String>>>> data1 = [];

  @override
Widget build(BuildContext context) {
  var store = context.read<MedicalTimetableStore>();
  return Scaffold(
    appBar: _buildAppBar(context),
    backgroundColor: OneStopColors.backgroundColor,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // MedicalDateSlider stays fixed at the top
            const SizedBox(
              height: 130,
              child: MedicalDateSlider(),
            ),
            const SizedBox(height: 10),
            // Scrollable content below
            Expanded(
              child: Observer(builder: (context) {
                return FutureBuilder(
                  future: store.initialiseMedicalTT(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListShimmer();
                    }
                    return Observer(builder: (context) {
                      return ListView.builder(
                        itemCount: store.todayMedicalTimeTable.length,
                        itemBuilder: (context, index) =>
                            store.todayMedicalTimeTable[index],
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

}



AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Medical TimeTable",
      textAlign: TextAlign.center,
      style: OnestopFonts.w500.size(20).setColor(kWhite),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.clear,
          color: kWhite,
        ),
      ),
    ],
  );
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);  // Use Uri.parse to handle the full URL
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw "Cannot launch URL";
  }
}