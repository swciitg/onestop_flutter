import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/notifications/notification_model.dart';
import 'package:onestop_dev/pages/notifications/notification_settings.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/notifications/notification_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  static String id = "/notifications";

  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  IconData getIcon(bool readNotif) {
    if (!readNotif) {
      return FluentIcons.circle_24_filled;
    }
    return Icons.brightness_1_outlined;
  }

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var store = context.read<CommonStore>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        actions: [
          !(LoginStore().isGuestUser)
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationSettings()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.settings,
                      color: kWhite2,
                    ),
                  ),
                )
              : Container()
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              FluentIcons.arrow_left_24_regular,
              color: kWhite2,
            )),
        title: Text(
          'Notifications',
          style: MyFonts.w500.setColor(kWhite2),
        ),
      ),
      body: FutureBuilder<Map<String, List<NotifsModel>>>(
          future: DataProvider.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorReloadScreen(reloadCallback: () {
                setState(() {});
              });
            }
            if (snapshot.hasData) {
              if (snapshot.data!["userPersonalNotifs"]!.isEmpty &&
                  snapshot.data!["allTopicNotifs"]!.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications found',
                    style: MyFonts.w300.setColor(kWhite),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: Colors.white,
                        controller: tabController,
                        onTap: (int index) {
                          if (index == 0) {
                            store.isPersonalNotif = true;
                          } else {
                            store.isPersonalNotif = false;
                          }
                        },
                        tabs: const [
                          Tab(
                              child: Text(
                            'Personal',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                          Tab(
                              child: Text(
                            'General',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Observer(builder: (context) {
                        return store.isPersonalNotif
                            ? Column(
                                children: [
                                  for (NotifsModel notif
                                      in snapshot.data!["userPersonalNotifs"]!)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: NotificationTile(
                                        notifModel: notif,
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                children: [
                                  for (NotifsModel notif
                                      in snapshot.data!["allTopicNotifs"]!)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: NotificationTile(
                                        notifModel: notif,
                                      ),
                                    ),
                                ],
                              );
                      }),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListShimmer(
                    count: 5,
                  )),
                ],
              );
            }
            return Center(
              child: Text(
                'No notifications found',
                style: MyFonts.w300.setColor(kWhite),
              ),
            );
          }),
      floatingActionButton: Observer(builder: (context) {
        return store.isPersonalNotif
            ? FloatingActionButton(
                onPressed: () async {
                  await APIService().deletePersonalNotif();
                },
                backgroundColor: lBlue2,
                child: const Icon(
                  Icons.delete,
                  color: OneStopColors.backgroundColor,
                ),
              )
            : Container();
      }),
    );
  }
}
