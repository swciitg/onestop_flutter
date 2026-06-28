import 'dart:async';

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
  String _searchQuery = "";
  Timer? _debounce;

  late final PagingController<int, LostModel> _lostController =
      PagingController(
        fetchPage: (pageKey) {
          return LnfRepository().getLostPage(pageKey, _searchQuery);
        },
        getNextPageKey: (state) {
          return state.lastPageIsEmpty ? null : state.nextIntPageKey;
        },
      );
  late final PagingController<int, FoundModel> _foundController =
      PagingController(
        fetchPage: (pageKey) {
          return LnfRepository().getFoundPage(pageKey, _searchQuery);
        },
        getNextPageKey: (state) {
          return state.lastPageIsEmpty ? null : state.nextIntPageKey;
        },
      );

  bool _showMyReports = false;

  void callSetState() {
    setState(() {});
  }

  String _formatDate(DateTime date) {
    final day = date.day;
    final month = _getMonthFormatter(date.month);
    final suffix = _getDaySuffix(day);
    return "$day$suffix $month ${date.year}";
  }

  String _getMonthFormatter(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: OColor.gray100,
          appBar: AppBar(
            backgroundColor: OColor.white,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            scrolledUnderElevation: 0,
            elevation: 0,
            systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle
                ?.copyWith(statusBarColor: OColor.white),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                FluentIcons.arrow_left_24_regular,
                color: OColor.gray800,
              ),
            ),
            title: Text(
              _showMyReports ? "My Reports" : "Lost and Found",
              style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: OSpacing.m,
                  vertical: OSpacing.xs,
                ),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(color: OColor.white),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabPill(
                          label: "Lost Items",
                          isActive: commonStore.lnfIndex == "Lost",
                          onTap: () => commonStore.setLnfIndex("Lost"),
                        ),
                      ),
                      Expanded(
                        child: _TabPill(
                          label: "Found Items",
                          isActive: commonStore.lnfIndex == "Found",
                          onTap: () => commonStore.setLnfIndex("Found"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Divider(height: 1, color: OColor.gray200),
              // Content
              OSearchBar(
                content: "Search Lost Items ",
                controller: _searchController,
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (_searchQuery != value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _lostController.refresh();
                      _foundController.refresh();
                    }
                  });
                },
              ),
              Expanded(
                child:
                    _showMyReports
                        ? _buildMyReports(commonStore)
                        : _buildAllItems(commonStore),
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
                              builder:
                                  (_) => BuySellForm(
                                    category: commonStore.lnfIndex,
                                  ),
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
                            borderRadius: BorderRadius.circular(
                              OCornerRadius.m,
                            ),
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
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.white,
                                ),
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
                            borderRadius: BorderRadius.circular(
                              OCornerRadius.m,
                            ),
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
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.green600,
                                ),
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
            padding: const EdgeInsets.all(OSpacing.s),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                bool showDate = false;
                if (index == 0) {
                  showDate = true;
                } else {
                  final prevItem = _lostController.value.items?[index - 1];
                  if (prevItem != null) {
                    final prevDate = prevItem.date.toLocal();
                    final currDate = item.date.toLocal();
                    if (prevDate.year != currDate.year ||
                        prevDate.month != currDate.month ||
                        prevDate.day != currDate.day) {
                      showDate = true;
                    }
                  }
                }

                if (showDate) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: OSpacing.s,
                          bottom: OSpacing.xs,
                          left: OSpacing.xs,
                        ),
                        child: Text(
                          _formatDate(item.date.toLocal()),
                          style: OTextStyle.labelMedium.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                      ),
                      LostFoundTile(currentModel: item),
                    ],
                  );
                }
                return LostFoundTile(currentModel: item);
              },
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
                  (context) =>
                      const PaginationText(text: "You've reached the end"),
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
            padding: const EdgeInsets.all(OSpacing.s),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                bool showDate = false;
                if (index == 0) {
                  showDate = true;
                } else {
                  final prevItem = _foundController.value.items?[index - 1];
                  if (prevItem != null) {
                    final prevDate = prevItem.date.toLocal();
                    final currDate = item.date.toLocal();
                    if (prevDate.year != currDate.year ||
                        prevDate.month != currDate.month ||
                        prevDate.day != currDate.day) {
                      showDate = true;
                    }
                  }
                }

                if (showDate) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: OSpacing.s,
                          bottom: OSpacing.xs,
                          left: OSpacing.xs,
                        ),
                        child: Text(
                          _formatDate(item.date.toLocal()),
                          style: OTextStyle.labelMedium.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                      ),
                      LostFoundTile(currentModel: item),
                    ],
                  );
                }
                return LostFoundTile(currentModel: item);
              },
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
                  (context) =>
                      const PaginationText(text: "You've reached the end"),
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
            padding: const EdgeInsets.all(OSpacing.s),
            itemBuilder: (context, index) => MyAdsTile(model: models[index]),
            separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
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
    _debounce?.cancel();
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
        child: Text(
          text,
          style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? OColor.gray200 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
        ),
        child: Text(
          label,
          style: OTextStyle.labelSmall.copyWith(
            color: isActive ? OColor.green600 : OColor.gray600,
          ),
        ),
      ),
    );
  }
}
