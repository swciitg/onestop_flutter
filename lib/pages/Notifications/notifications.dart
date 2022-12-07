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
  String? type;

  NotifsModel(
    this.hashcode,
    this.title,
    this.body,
    this.type,
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
            height: 200,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                child: Column(
                  children: [
                    Container(
                      height: 80,
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
  List<NotifsModel> n = [];
  Future<List<NotifsModel>> getDetails() async {
    n.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList('notifications')!;
    for (String r in result) {
      var parts = r.split(" ");
      NotifsModel not = new NotifsModel("", "", "","");
      if (parts.length >= 1) not.hashcode = parts[0];
      if (parts.length >= 2) not.title = parts[1];
      if (parts.length >= 3) not.body = parts[2];
      if (parts.length >= 4) not.type = parts[3];
      n.add(not);
    }
    return n;
  }
  IconData getIcon(String? type){
    if(type==null) return Icons.circle;
    else if(type=="Food" || type=="Lost and Found" || type=="TimeTable") return Icons.square;
    else return Icons.eject;
  }

  @override
  void initState() {
    getDetails();
    super.initState();
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
          // IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, NotifSettings.id);
          //     },
          //     icon: const Icon(Icons.settings)),
        ],
      ),
      body: FutureBuilder<List<NotifsModel>>(
          future: getDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          getIcon(snapshot.data![index].type),
                          color: kBlue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          snapshot.data![index].title!,
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
                },
              );
            }
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getLoadingIndicator(),
                ],
              ),
            );
          }),
    );
  }
}
