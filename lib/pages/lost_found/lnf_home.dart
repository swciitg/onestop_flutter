import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/lostfound/lost_found_tile.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
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

  bool _showMyReports = false;

  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: OColor.gray100,
          appBar: AppBar(
            backgroundColor: OColor.gray100,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
            ),
            title: Text(
              _showMyReports ? "My Reports" : "Lost and Found",
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
                      label: "Lost",
                      isActive: commonStore.lnfIndex == "Lost",
                      onTap: () => commonStore.setLnfIndex("Lost"),
                    ),
                    const SizedBox(width: OSpacing.xs),
                    _TabPill(
                      label: "Found",
                      isActive: commonStore.lnfIndex == "Found",
                      onTap: () => commonStore.setLnfIndex("Found"),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _showMyReports ? _buildMyReports(commonStore) : _buildAllItems(commonStore),
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
                      // Report Item FAB
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BuySellForm(category: commonStore.lnfIndex),
                            ),
                          );
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
                              Icon(
                                FluentIcons.arrow_routing_24_regular,
                                size: 20,
                                color: OColor.white,
                              ),
                              const SizedBox(width: OSpacing.xs),
                              Text(
                                'Report Item',
                                style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      // My Reports FAB
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMyReports = !_showMyReports;
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
                              Icon(
                                FluentIcons.arrow_routing_24_regular,
                                size: 20,
                                color: OColor.green600,
                              ),
                              const SizedBox(width: OSpacing.xs),
                              Text(
                                _showMyReports ? 'All Items' : 'My Reports',
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

  Widget _buildAllItems(CommonStore commonStore) {
    if (commonStore.lnfIndex == "Lost") {
      return PagingListener(
        controller: _lostController,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, LostModel>.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(OSpacing.m),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.m),
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => LostFoundTile(currentModel: item),
              firstPageErrorIndicatorBuilder:
                  (context) => ErrorReloadScreen(reloadCallback: () => _lostController.refresh()),
              noItemsFoundIndicatorBuilder:
                  (context) => const PaginationText(text: "No items found"),
              newPageErrorIndicatorBuilder:
                  (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: ErrorReloadButton(reloadCallback: () => _lostController.refresh()),
                  ),
              newPageProgressIndicatorBuilder:
                  (context) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              firstPageProgressIndicatorBuilder: (context) => ListShimmer(count: 5, height: 120),
              noMoreItemsIndicatorBuilder:
                  (context) => const PaginationText(text: "You've reached the end"),
            ),
          );
        },
      );
    } else {
      return PagingListener(
        controller: _foundController,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, FoundModel>.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(OSpacing.m),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.m),
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => LostFoundTile(currentModel: item),
              firstPageErrorIndicatorBuilder:
                  (context) => ErrorReloadScreen(reloadCallback: () => _foundController.refresh()),
              noItemsFoundIndicatorBuilder:
                  (context) => const PaginationText(text: "No items found"),
              newPageErrorIndicatorBuilder:
                  (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: ErrorReloadButton(reloadCallback: () => _foundController.refresh()),
                  ),
              newPageProgressIndicatorBuilder:
                  (context) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              firstPageProgressIndicatorBuilder: (context) => ListShimmer(count: 5, height: 120),
              noMoreItemsIndicatorBuilder:
                  (context) => const PaginationText(text: "You've reached the end"),
            ),
          );
        },
      );
    }
  }

  Widget _buildMyReports(CommonStore commonStore) {
    return FutureBuilder(
      future: LnfRepository().getLnfMyItems(
        LoginStore.userData['outlookEmail'] ?? "",
        commonStore.lnfIndex == "Lost",
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> models = snapshot.data!;
          if (models.isEmpty) {
            return Center(
              child: Text(
                "No reports posted yet",
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray600),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(OSpacing.m),
            itemBuilder: (context, index) => MyAdsTile(model: models[index]),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.m),
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
        child: Text(text, style: OTextStyle.labelSmall.copyWith(color: OColor.gray600)),
      ),
    );
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
