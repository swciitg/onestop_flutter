import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";

  const BuySellHome({Key? key}) : super(key: key);

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  final PagingController<int, BuyModel> _sellController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
  final PagingController<int, SellModel> _buyController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    _sellController.addPageRequestListener((pageKey) async {
      await listener(_sellController, APIRepository().getSellPage, pageKey);
    });
    _buyController.addPageRequestListener((pageKey) async {
      await listener(_buyController, APIRepository().getBuyPage, pageKey);
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
      controller.error = "An error occurred";
    }
  }

  void refresh() {
    _sellController.refresh();
    _buyController.refresh();
  }

  void retryLastFailedRequest() {
    _sellController.retryLastFailedRequest();
    _buyController.retryLastFailedRequest();
  }

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kBlueGrey,
            title: Text(
              "Buy and Sell",
              style: OnestopFonts.w500.size(20).setColor(kWhite),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 18,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  FluentIcons.dismiss_24_filled,
                  color: kWhite2,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                child: Row(
                  children: [
                    ItemType2(
                      commonStore: commonStore,
                      title: "Sell",
                      label: "For Sale",
                    ),
                    ItemType2(
                      commonStore: commonStore,
                      title: "Buy",
                      label: "Requested Item",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FutureBuilder(
                          future: APIRepository().getBnsMyItems(
                              LoginStore.userData['outlookEmail']!,
                              commonStore.bnsIndex == "Sell"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<BuyModel> models =
                                  snapshot.data! as List<BuyModel>;
                              List<MyAdsTile> tiles = models
                                  .map((e) => MyAdsTile(model: e))
                                  .toList();

                              if (tiles.isEmpty || LoginStore().isGuestUser) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text("My Ads",
                                          style: OneStopStyles.basicFontStyle
                                              .setColor(kWhite)),
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        tiles[index],
                                    itemCount: tiles.length,
                                  )
                                ]),
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text("All Ads",
                            style:
                                OneStopStyles.basicFontStyle.setColor(kWhite)),
                      ),
                    ),
                    if (commonStore.bnsIndex == "Sell")
                      PagedSliverList<int, BuyModel>(
                          pagingController: _sellController,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, sellItem, index) =>
                                BuyTile(model: sellItem),
                            firstPageErrorIndicatorBuilder: (context) =>
                                ErrorReloadScreen(reloadCallback: refresh),
                            noItemsFoundIndicatorBuilder: (context) =>
                                const PaginationText(text: "No items found"),
                            newPageErrorIndicatorBuilder: (context) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: ErrorReloadButton(
                                  reloadCallback: retryLastFailedRequest),
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
                                const PaginationText(
                                    text: "You've reached the end"),
                          ))
                    else if (commonStore.bnsIndex == "Buy")
                      PagedSliverList<int, SellModel>(
                          pagingController: _buyController,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, buyItem, index) =>
                                BuyTile(model: buyItem),
                            firstPageErrorIndicatorBuilder: (context) =>
                                ErrorReloadScreen(reloadCallback: refresh),
                            noItemsFoundIndicatorBuilder: (context) =>
                                const PaginationText(text: "No items found"),
                            newPageErrorIndicatorBuilder: (context) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: ErrorReloadButton(
                                  reloadCallback: retryLastFailedRequest),
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
                                const PaginationText(
                                    text: "You've reached the end"),
                          ))
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: LoginStore().isGuestUser
              ? Container()
              : AddItemButton(
                  type: commonStore.bnsIndex,
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sellController.dispose();
    _buyController.dispose();
    super.dispose();
  }
}

class ItemType2 extends StatelessWidget {
  const ItemType2(
      {Key? key, required this.commonStore, required this.title, this.label})
      : super(key: key);

  final CommonStore commonStore;
  final String title;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        commonStore.setBnsIndex(title);
      },
      child: ItemTypeBar(
        text: label ?? title,
        margin: const EdgeInsets.only(left: 8, bottom: 10),
        textStyle: OnestopFonts.w500
            .size(14)
            .setColor(commonStore.bnsIndex == title ? kBlack : kWhite),
        backgroundColor: commonStore.bnsIndex == title ? lBlue2 : kBlueGrey,
      ),
    );
  }
}
