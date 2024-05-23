import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_sell_search_bar.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/ui/guest_restrict.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
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
      await listener(_sellController, APIService().getSellPage, pageKey);
    });
    _buyController.addPageRequestListener((pageKey) async {
      await listener(_buyController, APIService().getBuyPage, pageKey);
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
              style: MyFonts.w500.size(20).setColor(kWhite),
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
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
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
                    ItemType2(commonStore: commonStore, title: "My Ads"),
                  ],
                ),
              ),
              if (commonStore.bnsIndex == "Sell")
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                        child: BnS_SearchBar(bnsIndex: "Sell"),
                      ),
                      Expanded(
                        child: PagedListView<int, BuyModel>(
                          pagingController: _sellController,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, sellItem, index) =>
                                BuyTile(model: sellItem),
                            firstPageErrorIndicatorBuilder: (context) =>
                                const PaginationText(text: "An error occurred"),
                            noItemsFoundIndicatorBuilder: (context) =>
                                const PaginationText(text: "No items found"),
                            newPageErrorIndicatorBuilder: (context) =>
                                const PaginationText(text: "An error occurred"),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (commonStore.bnsIndex == "Buy")
                Expanded(
                    child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                      child: BnS_SearchBar(bnsIndex: "Buy"),
                    ),
                    Expanded(
                      child: PagedListView<int, SellModel>(
                          pagingController: _buyController,
                          builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: (context, buyItem, index) =>
                                BuyTile(model: buyItem),
                            firstPageErrorIndicatorBuilder: (context) =>
                                const PaginationText(text: "An error occurred"),
                            noItemsFoundIndicatorBuilder: (context) =>
                                const PaginationText(text: "No items found"),
                            newPageErrorIndicatorBuilder: (context) =>
                                const PaginationText(text: "An error occurred"),
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
                          )),
                    )
                  ],
                ))
              else
                Expanded(
                  child: LoginStore().isGuestUser
                      ? const GuestRestrictAccess()
                      : FutureBuilder(
                          future: APIService().getBnsMyItems(
                              LoginStore.userData['outlookEmail']!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<BuyModel> models =
                                  snapshot.data! as List<BuyModel>;
                              List<MyAdsTile> tiles = models
                                  .map((e) => MyAdsTile(model: e))
                                  .toList();
                              if (LoginStore().isGuestUser) {
                                return const PaginationText(
                                    text:
                                        "Log in with your IITG account to post ads");
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
                            return ListShimmer(
                              count: 5,
                              height: 120,
                            );
                          }),
                )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
        textStyle: MyFonts.w500
            .size(14)
            .setColor(commonStore.bnsIndex == title ? kBlack : kWhite),
        backgroundColor: commonStore.bnsIndex == title ? lBlue2 : kBlueGrey,
      ),
    );
  }
}
