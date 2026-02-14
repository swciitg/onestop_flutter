import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/pages/buy_sell/my_ads.dart';
import 'package:onestop_dev/pages/buy_sell/post_ads.dart';
import 'package:onestop_ui/constants/corner_radius.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BuySellHome extends StatefulWidget {
  static const String id = "/buySellHome";

  const BuySellHome({super.key});

  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  final PagingController<int, BuyModel> _sellController = PagingController(
    fetchPage: (pageKey) => BnsRepository().getSellPage(pageKey),
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
  );

  final PagingController<int, SellModel> _buyController = PagingController(
    fetchPage: (pageKey) => BnsRepository().getBuyPage(pageKey),
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
  );

  @override
  Widget build(BuildContext context) {
    final commonStore = context.read<CommonStore>();

    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: OColor.white,
          appBar: AppBar(
            backgroundColor: OColor.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                FluentIcons.arrow_left_24_regular,
                color: OColor.green600,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Buy and Sell",
              style: OTextStyle.headingMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          /// BODY
          body: Stack(
            children: [
              Column(
                children: [
                  /// Tabs
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                     
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              text: "For sale",
                              active: commonStore.bnsIndex == "Sell",
                              onTap: () => commonStore.setBnsIndex("Sell"),
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              text: "Requested Item",
                              active: commonStore.bnsIndex == "Buy",
                              onTap: () => commonStore.setBnsIndex("Buy"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: OColor.white,
                        borderRadius: BorderRadius.circular(OCornerRadius.m),
                        border: Border.all(color: OColor.gray200, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Search Products",
                              style: OTextStyle.bodyMedium.copyWith(
                                color: OColor.gray600,
                              ),
                            ),
                          ),
                          Icon(
                            FluentIcons.search_24_regular,
                            color: OColor.gray600,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 Date Label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 0, 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "27th February",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  ///  Grid or List
                  Expanded(
                    child: commonStore.bnsIndex == "Sell"
                        ? _sellGridView()
                        : _buyListView(),
                  ),
                ],
              ),
                            
              ///  POST / MY ADS BUTTONS
              if (!LoginStore().isGuestUser)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PostAdButton(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostAdSelection())); 
                        },
                      ),
                      const SizedBox(height: 12),
                      _MyAdsButton(
                        onTap: () {
                         
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAdsScreen()));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  ///  SELL GRID VIEW
  Widget _sellGridView() {
    return PagingListener(
      controller: _sellController,
      builder: (_, state, fetchNext) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: PagedSliverGrid(
                state: state,
                fetchNextPage: fetchNext,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (_, item, __) => _SellProductCard(model: item),
                  firstPageProgressIndicatorBuilder: (_) =>
                       ListShimmer(count: 6, height: 220),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///  BUY LIST VIEW
  Widget _buyListView() {
    return PagingListener(
      controller: _buyController,
      builder: (_, state, fetchNext) {
        return PagedListView(
          state: state,
          fetchNextPage: fetchNext,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (_, item, __) => _BuyRequestCard(model: item),
            firstPageProgressIndicatorBuilder: (_) =>
                 ListShimmer(count: 6, height: 100),
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

/// ---------------- TAB BUTTON ----------------

class _TabButton extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? OColor.gray200 : Colors.transparent,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
        ),
        child: Text(
          text,
          style: OTextStyle.labelMedium.copyWith(
            color: active ? OColor.green600 : OColor.gray600,
            fontWeight: active ? FontWeight.w500 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// ---------------- SELL PRODUCT CARD (GRID) ----------------

class _SellProductCard extends StatelessWidget {
  final dynamic model;

  const _SellProductCard({required this.model});

  void _showSellProductDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SellProductDetailSheet(model: model),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return GestureDetector(
      onTap: () => _showSellProductDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(OCornerRadius.m),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? "",
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    memCacheWidth: 468,
                    memCacheHeight: 420,
                    placeholder: (_, __) => _imageFallback(),
                    errorWidget: (_, __, ___) => _imageFallback(),
                  ),
                ),

                if (model.isNew == true)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: OColor.blue100,
                        borderRadius: BorderRadius.circular(OCornerRadius.l),
                      ),
                      child: Text(
                        "BRAND NEW",
                        style: OTextStyle.labelXSmall.copyWith(
                          color: OColor.blue500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title ?? "Product Name",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: OTextStyle.bodySmall.copyWith(
                      color: OColor.gray800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${model.price ?? '40'}",
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 140,
      color: OColor.gray400,
    );
  }
}

/// ---------------- BUY REQUEST CARD (LIST) ----------------

class _BuyRequestCard extends StatelessWidget {
  final dynamic model;

  const _BuyRequestCard({required this.model});

  void _showBuyRequestDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BuyRequestDetailSheet(model: model),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return GestureDetector(
      onTap: () => _showBuyRequestDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200, width: 1),
        ),
        child: Column(
          children: [
            Row(
          children: [
           
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: OColor.gray100,
                borderRadius: BorderRadius.circular(OCornerRadius.s),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(OCornerRadius.s),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 180, 
                        memCacheHeight: 180,
                        placeholder: (_, __) => Icon(
                          FluentIcons.image_24_regular,
                          color: OColor.gray400,
                          size: 24,
                        ),
                        errorWidget: (_, __, ___) => Icon(
                          FluentIcons.image_24_regular,
                          color: OColor.gray400,
                          size: 24,
                        ),
                      ),
                    )
                  : Icon(
                      FluentIcons.image_24_regular,
                      color: OColor.gray400,
                      size: 24,
                    ),
            ),

            const SizedBox(width: 12),

           
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                  children: [
                     Text(
                    model.title ?? "Item Name",
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                   const Spacer(),

            Icon(
              FluentIcons.chevron_right_24_regular,
              color: OColor.gray400,
              size: 20,
            ),
                  ],
                 ),
                  const SizedBox(height:6),
                  Text(
                    "PRICE LABEL",
                    style: OTextStyle.labelXSmall.copyWith(
                      color: OColor.gray600,
                    ),
                  ),
                  Text(
                    "Price",
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.gray800,
                    ),
                  ),
                  const SizedBox(height: 8),

                 
                ],
              ),
            ),

           
          ],
        ),
         Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: OColor.gray200,
      ),
    ),

               Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: OColor.gray300,
                        backgroundImage: model.user?.image != null
                            ? CachedNetworkImageProvider(
                                model.user!.image!,
                                maxWidth: 60, 
                                maxHeight: 60,
                              )
                            : null,
                        child: model.user?.imageURL == null
                            ? Icon(Icons.person,
                                color: OColor.gray600, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        model.user?.name ?? "Name",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray700,
                        ),
                      ),
                      const Spacer(),
                      
                IconButton(
                  icon: Icon(
                    FluentIcons.call_24_regular,
                    color: OColor.green600,
                    size: 24,
                  ),
                  onPressed: () {
                    if (model.user?.phoneNumber != null) {
                      _launchUrl('tel:${model.user!.phoneNumber}');
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
               
                IconButton(
                  icon: Icon(
                    FluentIcons.chat_24_regular,
                    color: OColor.green600,
                    size: 24,
                  ),
                  onPressed: () {
                    if (model.user?.outlookEmail != null) {
                      _launchUrl('sms:${model.user!.outlookEmail}');
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            
                    ],
                  ),
          ],
        )
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// ---------------- SELL PRODUCT DETAIL SHEET ----------------

class _SellProductDetailSheet extends StatelessWidget {
  final dynamic model;

  const _SellProductDetailSheet({required this.model});

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
          
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.title ?? "Item Name",
                      style: OTextStyle.headingSmall.copyWith(
                        color: OColor.gray800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: OColor.gray600),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

             
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      ClipRRect(
                        borderRadius: BorderRadius.circular(OCornerRadius.l),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl ?? "",
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 1080, 
                          memCacheHeight: 840,
                          placeholder: (_, __) => Container(
                            height: 280,
                            color: OColor.gray300,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 280,
                            color: OColor.gray300,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                
                      Text(
                        "Asking Price",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ ${model.price ?? '0'}",
                        style: OTextStyle.headingMedium.copyWith(
                          color: OColor.gray800,
                          fontWeight: FontWeight.w500,
                          
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      Text(
                        "Description",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.description ?? "No description provided.",
                        style: OTextStyle.bodyMedium.copyWith(
                          color: OColor.gray800,
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      if (model.isNew == true)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: OColor.blue500,
                            borderRadius: BorderRadius.circular(OCornerRadius.m),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                FluentIcons.star_24_filled,
                                color: OColor.white,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Brand New Item",
                                      style: OTextStyle.labelMedium.copyWith(
                                        color: OColor.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "This item is brand new and has never been used.",
                                      style: OTextStyle.bodySmall.copyWith(
                                        color: OColor.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                   
                      Text(
                        "Posted by",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: OColor.gray300,
                            backgroundImage: model.user?.image != null
                                ? CachedNetworkImageProvider(
                                    model.user!.image!,
                                    maxWidth: 120, 
                                    maxHeight: 120,
                                  )
                                : null,
                            child: model.user?.image == null
                                ? Icon(Icons.person, color: OColor.gray600)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.user?.name ?? "N/A",
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.gray800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                 model.user?.outlookEmail ?? model.user?.altEmail ?? "N/A",
                                style: OTextStyle.bodySmall.copyWith(
                                  color: OColor.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.call_24_regular,
                              label: "Call",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.phoneNumber != null) {
                                  _launchUrl('tel:${model.user!.phoneNumber}');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.chat_24_regular,
                              label: "Text",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.phoneNumber != null) {
                                  _launchUrl('sms:${model.user!.phoneNumber}');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.mail_24_regular,
                              label: "Mail",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.outlookEmail != null) {
                                  _launchUrl('mailto:${model.user!.outlookEmail}');
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// ---------------- BUY REQUEST DETAIL SHEET ----------------

class _BuyRequestDetailSheet extends StatelessWidget {
  final dynamic model;

  const _BuyRequestDetailSheet({required this.model});

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(OCornerRadius.l),
            ),
          ),
          child: Column(
            children: [
             
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.title ?? "Item Name",
                      style: OTextStyle.headingSmall.copyWith(
                        color: OColor.gray800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: OColor.gray600),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      ClipRRect(
                        borderRadius: BorderRadius.circular(OCornerRadius.l),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl ?? "",
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          memCacheWidth: 1080,
                          memCacheHeight: 720,
                          placeholder: (_, __) => Container(
                            height: 240,
                            color: OColor.gray300,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 240,
                            color: OColor.gray300,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                     
                      Text(
                        "Offered Price",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ ${model.price ?? '0'}",
                        style: OTextStyle.headingMedium.copyWith(
                          color: OColor.gray800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      Text(
                        "Requested by",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: OColor.gray300,
                            backgroundImage: model.user?.image != null
                                ? CachedNetworkImageProvider(
                                    model.user!.image!,
                                    maxWidth: 120, 
                                    maxHeight: 120,
                                  )
                                : null,
                            child: model.user?.image == null
                                ? Icon(Icons.person, color: OColor.gray600)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.user?.name ?? "N/A",
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.gray800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                model.user?.email ?? "N/A",
                                style: OTextStyle.bodySmall.copyWith(
                                  color: OColor.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.call_24_regular,
                              label: "Call",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.phoneNumber != null) {
                                  _launchUrl('tel:${model.user!.phoneNumber}');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.chat_24_regular,
                              label: "Text",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.phoneNumber != null) {
                                  _launchUrl('sms:${model.user!.phoneNumber}');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactButton(
                              icon: FluentIcons.mail_24_regular,
                              label: "Mail",
                              color: OColor.green600,
                              onTap: () {
                                if (model.user?.outlookEmail != null) {
                                  _launchUrl('mailto:${model.user!.outlookEmail}');
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// ---------------- CONTACT BUTTON ----------------

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OColor.white,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: OColor.gray300, width: 1.5),
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(
                label,
                style: OTextStyle.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- ACTION BUTTONS ----------------

class _PostAdButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PostAdButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: onTap,
       borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: OColor.green600,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 18,
                color: OColor.white,
              ),
              const SizedBox(width: 6),
              Text(
                "Post an Ad",
                style: OTextStyle.labelMedium.copyWith(
                  color: OColor.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyAdsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MyAdsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
           
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.list_alt,
                size: 18,
                color: OColor.green600,
              ),
              const SizedBox(width: 6),
              Text(
                "My Ads",
                style: OTextStyle.labelMedium.copyWith(
                  color: OColor.green600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}