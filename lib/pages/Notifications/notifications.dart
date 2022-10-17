import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/Notifications/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NotifsModel {
  String? hashcode;
  String? title;
  String? body;

  NotifsModel(
    this.hashcode,
    this.title,
    this.body,
  );
}

class Notif extends StatefulWidget {
  static String id = "notifications";
  const Notif({Key? key}) : super(key: key);

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  Widget _getLoadingIndicator() {
    return Expanded(
      child: Shimmer.fromColors(
          period: const Duration(seconds: 1),
          baseColor: kHomeTile,
          highlightColor: lGrey,
          child: SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    // Divider(
                    //   thickness: 1.5,
                    //   color: kTabBar,
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<List<String>> getDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList('notifications')!;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        leadingWidth: 30,
        title: Text(
          'Notifications',
          style: MyFonts.w500,
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushNamed(context, NotifSettings.id);
          }, icon: const Icon(Icons.settings)),
        ],
      ),
      body: FutureBuilder<List<String>>(
          future: getDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.square,color: kBlue,),
                          SizedBox(width: 10,),
                          Text(
                            snapshot.data![index],
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kWhite,
                              letterSpacing: 0.1,
                              height: 1.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },);
            }
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext buildContext, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 16),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getLoadingIndicator(),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
