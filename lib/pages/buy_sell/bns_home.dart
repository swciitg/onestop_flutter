import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/pages/buy_sell/post_ad_choice.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';

class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";

  const BuySellHome({super.key});

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  final PagingController<int, BuyModel> _sellController = PagingController(
    fetchPage: (pageKey) {
      return BnsRepository().getSellPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );

  final PagingController<int, SellModel> _buyController = PagingController(
    fetchPage: (pageKey) {
      return BnsRepository().getBuyPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );

  bool _showMyAds = false;

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: OColor.gray100,
          appBar: AppBar(
            backgroundColor: OColor.white,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            scrolledUnderElevation: 0,
            elevation: 0,
            systemOverlayStyle: Theme.of(
              context,
            ).appBarTheme.systemOverlayStyle?.copyWith(statusBarColor: OColor.white),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
            ),
            title: Text(
              _showMyAds ? "My Ads" : "Buy and Sell",
              style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
            ),
          ),
          body: Column(
            children: [
              Divider(height: 1, color: OColor.gray200),
              // Tab pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
                child: Row(
                  children: [
                    _TabPill(
                      label: "For sale",
                      isActive: commonStore.bnsIndex == "Sell",
                      onTap: () => commonStore.setBnsIndex("Sell"),
                    ),
                    const SizedBox(width: OSpacing.xs),
                    _TabPill(
                      label: "Requested Item",
                      isActive: commonStore.bnsIndex == "Buy",
                      onTap: () => commonStore.setBnsIndex("Buy"),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _showMyAds ? _buildMyAdsGrid(commonStore) : _buildAllAdsGrid(commonStore),
              ),
            ],
          ),
          floatingActionButton:
              LoginStore().isGuestUser
                  ? null
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Post an Ad FAB
                      GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (_) => const PostAdChoice()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: OSpacing.m,
                            vertical: OSpacing.s,
                          ),
                          decoration: BoxDecoration(
                            color: OColor.green600,
                            borderRadius: BorderRadius.circular(OCornerRadius.m),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FluentIcons.edit_24_regular, size: 20, color: OColor.white),
                              const SizedBox(width: OSpacing.xs),
                              Text(
                                'Post an Ad',
                                style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      // My Ads FAB
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMyAds = !_showMyAds;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: OSpacing.m,
                            vertical: OSpacing.s,
                          ),
                          decoration: BoxDecoration(
                            color: OColor.white,
                            borderRadius: BorderRadius.circular(OCornerRadius.m),
                            border: Border.all(color: OColor.gray300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FluentIcons.person_24_regular, size: 20, color: OColor.green600),
                              const SizedBox(width: OSpacing.xs),
                              Text(
                                _showMyAds ? 'All Ads' : 'My Ads',
                                style: OTextStyle.labelMedium.copyWith(color: OColor.green600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  // All Ads grid
  Widget _buildAllAdsGrid(CommonStore commonStore) {
    if (commonStore.bnsIndex == "Sell") {
      return PagingListener(
        controller: _sellController,
        builder: (context, state, fetchNextPage) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(OSpacing.s),
                sliver: PagedSliverGrid<int, BuyModel>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: OSpacing.xs,
                    mainAxisSpacing: OSpacing.xs,
                    childAspectRatio: 0.68,
                  ),
                  builderDelegate: _buildSellDelegate(),
                ),
              ),
            ],
          );
        },
      );
    } else {
      return PagingListener(
        controller: _buyController,
        builder: (context, state, fetchNextPage) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(OSpacing.s),
                sliver: PagedSliverGrid<int, SellModel>(
                  state: state,
                  fetchNextPage: fetchNextPage,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: OSpacing.xs,
                    mainAxisSpacing: OSpacing.xs,
                    childAspectRatio: 0.68,
                  ),
                  builderDelegate: _buildBuyDelegate(),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  // My Ads grid
  Widget _buildMyAdsGrid(CommonStore commonStore) {
    return FutureBuilder(
      future: BnsRepository().getBnsMyItems(
        LoginStore.userData['outlookEmail']!,
        commonStore.bnsIndex == "Sell",
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<BuyModel> models = snapshot.data!;
          if (models.isEmpty) {
            return Center(
              child: Text(
                "No ads posted yet",
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(OSpacing.s),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: OSpacing.xs,
              mainAxisSpacing: OSpacing.xs,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) => MyAdsTile(model: models[index]),
            itemCount: models.length,
          );
        }
        if (snapshot.hasError) {
          return ErrorReloadScreen(reloadCallback: callSetState);
        }
        return ListShimmer(count: 5, height: 120);
      },
    );
  }

  PagedChildBuilderDelegate<BuyModel> _buildSellDelegate() {
    return PagedChildBuilderDelegate(
      itemBuilder: (context, item, index) => BuyTile(model: item),
      firstPageErrorIndicatorBuilder:
          (context) => ErrorReloadScreen(reloadCallback: () => _sellController.refresh()),
      noItemsFoundIndicatorBuilder: (context) => const PaginationText(text: "No items found"),
      newPageErrorIndicatorBuilder:
          (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: ErrorReloadButton(reloadCallback: () => _sellController.refresh()),
          ),
      newPageProgressIndicatorBuilder:
          (context) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      firstPageProgressIndicatorBuilder: (context) => ListShimmer(count: 5, height: 120),
      noMoreItemsIndicatorBuilder:
          (context) => const PaginationText(text: "You've reached the end"),
    );
  }

  PagedChildBuilderDelegate<SellModel> _buildBuyDelegate() {
    return PagedChildBuilderDelegate(
      itemBuilder: (context, item, index) => BuyTile(model: item),
      firstPageErrorIndicatorBuilder:
          (context) => ErrorReloadScreen(reloadCallback: () => _buyController.refresh()),
      noItemsFoundIndicatorBuilder: (context) => const PaginationText(text: "No items found"),
      newPageErrorIndicatorBuilder:
          (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: ErrorReloadButton(reloadCallback: () => _buyController.refresh()),
          ),
      newPageProgressIndicatorBuilder:
          (context) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      firstPageProgressIndicatorBuilder: (context) => ListShimmer(count: 5, height: 120),
      noMoreItemsIndicatorBuilder:
          (context) => const PaginationText(text: "You've reached the end"),
    );
  }

  @override
  void dispose() {
    _sellController.dispose();
    _buyController.dispose();
    super.dispose();
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
        decoration: BoxDecoration(
          color: isActive ? OColor.gray200 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
        ),
        child: Text(
          label,
          style: OTextStyle.labelSmall.copyWith(color: isActive ? OColor.green600 : OColor.gray600),
        ),
      ),
    );
  }
}
