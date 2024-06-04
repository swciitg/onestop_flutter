import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_button.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_tile.dart';
import 'package:onestop_dev/widgets/ui/guest_restrict.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";

  const LostFoundHome({Key? key}) : super(key: key);

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {
  final PagingController<int, LostModel> _lostController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, FoundModel> _foundController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    _lostController.addPageRequestListener((pageKey) async {
      await listener(_lostController, APIService().getLostPage, pageKey);
    });
    _foundController.addPageRequestListener((pageKey) async {
      await listener(_foundController, APIService().getFoundPage, pageKey);
    });
  }

  Future<void> listener(
      PagingController controller, Function apiCall, int pageKey) async {
    try {
      var result = await apiCall(pageKey);
      bool isLastPage = false;
      if (result.length < CommonStore().pageSize) {
        isLastPage = true;
      }
      if (mounted) {
        if (isLastPage) {
          controller.appendLastPage(result);
        } else {
          controller.appendPage(result, pageKey + 1);
        }
      }
    } catch (e) {
      controller.error = e;
    }
  }

  void callSetState() {
    setState(() {});
  }

  void refreshControllers() {
    _lostController.refresh();
    _foundController.refresh();
  }

  void retryLastFailedRequest() {
    _lostController.retryLastFailedRequest();
    _foundController.retryLastFailedRequest();
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueGrey,
          title: Text(
            "Lost and Found",
            style: MyFonts.w500.size(20).setColor(kWhite),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 18,
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            //   child: ,
            // )
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  FluentIcons.dismiss_24_filled,
                  color: kWhite2,
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  LostFoundButton(
                    label: "Lost Items",
                    store: commonStore,
                    category: "Lost",
                  ),
                  LostFoundButton(
                    store: commonStore,
                    label: "Found Items",
                    category: "Found",
                  ),
                  LostFoundButton(
                    store: commonStore,
                    label: "My Ads",
                    category: "My Ads",
                  ),
                ],
              ),
            ),
            if (commonStore.lnfIndex == "Lost")
              Expanded(
                child: PagedListView<int, LostModel>(
                    pagingController: _lostController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, lostItem, index) =>
                          LostFoundTile(currentModel: lostItem),
                      firstPageErrorIndicatorBuilder: (context) =>
                          ErrorReloadScreen(reloadCallback: refreshControllers),
                      noItemsFoundIndicatorBuilder: (context) =>
                          const PaginationText(text: "No items found"),
                      newPageErrorIndicatorBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ErrorReloadButton(
                          reloadCallback: retryLastFailedRequest,
                        ),
                      ),
                      newPageProgressIndicatorBuilder: (context) =>
                          const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      firstPageProgressIndicatorBuilder: (context) =>
                          ListShimmer(
                        count: 5,
                        height: 120,
                      ),
                      noMoreItemsIndicatorBuilder: (context) =>
                          const PaginationText(text: "You've reached the end"),
                    )),
              )
            else if (commonStore.lnfIndex == "Found")
              Expanded(
                child: PagedListView<int, FoundModel>(
                    pagingController: _foundController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, lostItem, index) =>
                          LostFoundTile(currentModel: lostItem),
                      firstPageErrorIndicatorBuilder: (context) =>
                          ErrorReloadScreen(reloadCallback: refreshControllers),
                      noItemsFoundIndicatorBuilder: (context) =>
                          const PaginationText(text: "No items found"),
                      newPageErrorIndicatorBuilder: (context) =>
                          ErrorReloadButton(
                              reloadCallback: retryLastFailedRequest),
                      newPageProgressIndicatorBuilder: (context) =>
                          const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      firstPageProgressIndicatorBuilder: (context) =>
                          ListShimmer(
                        count: 5,
                        height: 120,
                      ),
                      noMoreItemsIndicatorBuilder: (context) =>
                          const PaginationText(text: "You've reached the end"),
                    )),
              )
            else
              Expanded(
                child: LoginStore().isGuestUser
                    ? const GuestRestrictAccess()
                    : FutureBuilder(
                        future: APIService().getLnfMyItems(
                            LoginStore.userData['outlookEmail'] ?? ""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> models =
                                snapshot.data! as List<dynamic>;
                            List<MyAdsTile> tiles =
                                models.map((e) => MyAdsTile(model: e)).toList();
                            if (LoginStore().isGuestUser) {
                              return const PaginationText(
                                  text: "Log in with your IITG "
                                      "account to post ads");
                            }
                            if (tiles.isEmpty) {
                              return const PaginationText(
                                  text: "You haven't posted any ads");
                            }
                            return ListView.builder(
                              itemBuilder: (context, index) => tiles[index],
                              itemCount: tiles.length,
                            );
                          }
                          if (snapshot.hasError) {
                            return ErrorReloadScreen(
                                reloadCallback: callSetState);
                          }
                          return ListShimmer(
                            count: 5,
                            height: 120,
                          );
                        }),
              ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LoginStore().isGuestUser
            ? Container()
            : AddItemButton(
                type: commonStore.lnfIndex,
              ),
      );
    });
  }

  @override
  void dispose() {
    _lostController.dispose();
    _foundController.dispose();
    super.dispose();
  }
}

class PaginationText extends StatelessWidget {
  final String text;

  const PaginationText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: MyFonts.w400.setColor(kWhite),
        ),
      ),
    );
  }
}
