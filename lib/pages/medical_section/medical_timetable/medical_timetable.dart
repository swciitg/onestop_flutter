import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/stores/medical_timetable_store.dart'; 
import 'package:onestop_dev/widgets/medicalsection/medical_date_slider.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

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
    return LoginStore.isGuest
        ? const GuestRestrictAccess()
        : Scaffold(
          appBar: _buildAppBar(context),
      backgroundColor: OneStopColors.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                  child: Observer(builder: (context) {
                    return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                //Day selector
                                const SizedBox(
                                  height: 130,
                                  child: MedicalDateSlider(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                    future: store.initialiseMedicalTT(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return ListShimmer();
                                      }
                                      return Observer(builder: (context) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ClampingScrollPhysics(),
                                            itemCount:
                                                store.todayMedicalTimeTable.length,
                                            itemBuilder: (context, index) =>
                                                store.todayMedicalTimeTable[index]);
                                      });
                                    }),
                              ],
                            ),
                          ],
                        );
                  }),
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