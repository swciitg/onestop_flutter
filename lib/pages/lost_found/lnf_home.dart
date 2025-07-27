import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_button.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:provider/provider.dart';

class LostFoundHome extends StatefulWidget {
  static const id = "/lostFoundHome";

  const LostFoundHome({super.key});

  @override
  State<LostFoundHome> createState() => _LostFoundHomeState();
}

class _LostFoundHomeState extends State<LostFoundHome> {
  final PagingController<int, LostModel> _lostController = PagingController(
    fetchPage: (pageKey) {
      return LnfRepository().getLostPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );
  final PagingController<int, FoundModel> _foundController = PagingController(
    fetchPage: (pageKey) {
      return LnfRepository().getFoundPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kBlueGrey,
            title: Text("Lost and Found", style: OnestopFonts.w500.size(20).setColor(kWhite)),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 18,
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(FluentIcons.dismiss_24_filled, color: kWhite2),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    LostFoundButton(label: "Lost Items", store: commonStore, category: "Lost"),
                    LostFoundButton(store: commonStore, label: "Found Items", category: "Found"),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FutureBuilder(
                        future: LnfRepository().getLnfMyItems(
                          LoginStore.userData['outlookEmail'] ?? "",
                          commonStore.lnfIndex == "Lost",
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> models = snapshot.data!;
                            List<MyAdsTile> tiles = models.map((e) => MyAdsTile(model: e)).toList();
                            if (tiles.isEmpty || LoginStore().isGuestUser) {
                              return const SizedBox();
                            }
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      "My Ads",
                                      style: OneStopStyles.basicFontStyle.setColor(kWhite),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => tiles[index],
                                  itemCount: tiles.length,
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            return ErrorReloadScreen(reloadCallback: callSetState);
                          }
                          return ListShimmer(count: 5, height: 120);
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "All Ads",
                          style: OneStopStyles.basicFontStyle.setColor(kWhite),
                        ),
                      ),
                    ),
                    if (commonStore.lnfIndex == "Lost")
                      PagingListener(
                        controller: _lostController,
                        builder: (context, state, fetchNextPage) {
                          return PagedSliverList<int, LostModel>(
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder:
                                  (context, lostItem, index) =>
                                      LostFoundTile(currentModel: lostItem),
                              firstPageErrorIndicatorBuilder:
                                  (context) => ErrorReloadScreen(
                                    reloadCallback: () => _lostController.refresh(),
                                  ),
                              noItemsFoundIndicatorBuilder:
                                  (context) => const PaginationText(text: "No items found"),
                              newPageErrorIndicatorBuilder:
                                  (context) => Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ErrorReloadButton(
                                      reloadCallback: () => _lostController.refresh(),
                                    ),
                                  ),
                              newPageProgressIndicatorBuilder:
                                  (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                              firstPageProgressIndicatorBuilder:
                                  (context) => ListShimmer(count: 5, height: 120),
                              noMoreItemsIndicatorBuilder:
                                  (context) => const PaginationText(text: "You've reached the end"),
                            ),
                          );
                        },
                      )
                    else if (commonStore.lnfIndex == "Found")
                      PagingListener(
                        controller: _foundController,
                        builder: (context, state, fetchNextPage) {
                          return PagedSliverList<int, FoundModel>(
                            state: state,
                            fetchNextPage: fetchNextPage,
                            builderDelegate: PagedChildBuilderDelegate(
                              itemBuilder:
                                  (context, lostItem, index) =>
                                      LostFoundTile(currentModel: lostItem),
                              firstPageErrorIndicatorBuilder:
                                  (context) => ErrorReloadScreen(
                                    reloadCallback: () => _foundController.refresh(),
                                  ),
                              noItemsFoundIndicatorBuilder:
                                  (context) => const PaginationText(text: "No items found"),
                              newPageErrorIndicatorBuilder:
                                  (context) => Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ErrorReloadButton(
                                      reloadCallback: () => _foundController.refresh(),
                                    ),
                                  ),
                              newPageProgressIndicatorBuilder:
                                  (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                              firstPageProgressIndicatorBuilder:
                                  (context) => ListShimmer(count: 5, height: 120),
                              noMoreItemsIndicatorBuilder:
                                  (context) => const PaginationText(text: "You've reached the end"),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              LoginStore().isGuestUser ? Container() : AddItemButton(type: commonStore.lnfIndex),
        );
      },
    );
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

  const PaginationText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: OnestopFonts.w400.setColor(kWhite)),
      ),
    );
  }
}
