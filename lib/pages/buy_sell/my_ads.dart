import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/constants/corner_radius.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/pages/buy_sell/sell_form.dart';

class MyAdsScreen extends StatefulWidget {
  static const String id = "/myAds";

  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  late Future<List<BuyModel>> _sellFuture;
  late Future<List<BuyModel>> _buyFuture;
  late String _email;

  @override
  void initState() {
    super.initState();
    
    _email = LoginStore.userData["outlookEmail"]?.toString() ?? '';

    _sellFuture = BnsRepository().getBnsMyItems(_email, true);
    _buyFuture  = BnsRepository().getBnsMyItems(_email, false);
  }

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
                color: OColor.gray800,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "My ads",
              style: OTextStyle.headingMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Column(
            children: [
             
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                  ),
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

             
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: OColor.white,
                    borderRadius: BorderRadius.circular(OCornerRadius.m),
                    border: Border.all(color: OColor.gray300, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Search your ads",
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

              
              Expanded(
                child: commonStore.bnsIndex == "Sell"
                    ? _buildSellGrid()
                    : _buildBuyGrid(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSellGrid() {
    return FutureBuilder<List<BuyModel>>(
      future: _sellFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  ListShimmer(count: 6, height: 240);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No ads posted"));
        }

        final items = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) =>
              _MyAdCard(model: items[i], isSell: true),
        );
      },
    );
  }

  Widget _buildBuyGrid() {
    return FutureBuilder<List<BuyModel>>(
      future: _buyFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  ListShimmer(count: 6, height: 100);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No requests"));
        }

        final items = snapshot.data!;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) =>
              _MyRequestCard(model: items[i]),
        );
      },
    );
  }
}

//---------------- REQUEST CARD (LIST FOR BUY) ----------------

class _MyRequestCard extends StatelessWidget {
  final dynamic model;

  const _MyRequestCard({required this.model});

  void _showRequestDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MyAdDetailSheet(model: model, isSell: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return GestureDetector(
      onTap: () => _showRequestDetail(context),
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
                      Text(
                        model.title?.toString() ?? "Item Name",
                        style: OTextStyle.bodyMedium.copyWith(
                          color: OColor.gray800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "PRICE LABEL",
                        style: OTextStyle.labelXSmall.copyWith(
                          color: OColor.gray500,
                        ),
                      ),
                      Text(
                        "₹${model.price?.toString() ?? '0'}",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray800,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
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
                _ActionButton(
                  icon: FluentIcons.edit_24_regular,
                  label: "Edit",
                  color: OColor.green600,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellItemForm(
                          type: "Buy",
                          existingItem: model,
                        ),
                      ),
                    );
                   
                    if (result == true && context.mounted) {
                      //  can add refresh logic here
                    }
                  },
                ),
                const Spacer(),
                _ActionButton(
                  icon: FluentIcons.delete_24_regular,
                  label: "Delete",
                  color: OColor.red600,
                  onTap: () {
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Request'),
        content: Text('Are you sure you want to delete this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: OColor.red600)),
          ),
        ],
      ),
    );
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
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// ----------------  AD CARD (GRID FOR SELL) ----------------

class _MyAdCard extends StatelessWidget {
  final dynamic model;
  final bool isSell;

  const _MyAdCard({required this.model, required this.isSell});

  void _showAdDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MyAdDetailSheet(model: model, isSell: isSell),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.compressedImageURL?.isNotEmpty == true
        ? model.compressedImageURL
        : model.imageURL;

    return GestureDetector(
      onTap: () => _showAdDetail(context),
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
                        borderRadius: BorderRadius.circular(OCornerRadius.s),
                      ),
                      child: Text(
                        "BRAND NEW",
                        style: OTextStyle.labelXSmall.copyWith(
                          color: OColor.blue600,
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
                    model.title?.toString() ?? "Product Name",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: OTextStyle.bodySmall.copyWith(
                      color: OColor.gray800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${model.price?.toString() ?? '0'}",
                    style: OTextStyle.labelMedium.copyWith(
                      color: OColor.gray800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: FluentIcons.edit_24_regular,
                          label: "Edit",
                          color: OColor.green600,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SellItemForm(
                                  type: "Sell",
                                  existingItem: model,
                                ),
                              ),
                            );
                            // Refresh if needed
                            if (result == true && context.mounted) {
                              // You can add refresh logic here
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          icon: FluentIcons.delete_24_regular,
                          label: "Delete",
                          color: OColor.red600,
                          onTap: () {
                            _showDeleteConfirmation(context);
                          },
                        ),
                      ),
                    ],
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Ad'),
        content: Text('Are you sure you want to delete this ad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: OColor.red600)),
          ),
        ],
      ),
    );
  }
}

/// ---------------- ACTION BUTTON ----------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: OTextStyle.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------  AD DETAIL SHEET ----------------

class _MyAdDetailSheet extends StatelessWidget {
  final dynamic model;
  final bool isSell;

  const _MyAdDetailSheet({required this.model, required this.isSell});

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
                      model.title?.toString() ?? "Item Name",
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
                        isSell ? "Asking Price" : "Offered Price",
                        style: OTextStyle.bodySmall.copyWith(
                          color: OColor.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹ ${model.price?.toString() ?? '0'}",
                        style: OTextStyle.headingMedium.copyWith(
                          color: OColor.gray800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                      if (isSell) ...[
                        Text(
                          "Description",
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model.description?.toString() ?? "No description provided",
                          style: OTextStyle.bodyMedium.copyWith(
                            color: OColor.gray800,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      
                      if (isSell && model.isNew == true) ...[
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
                      ],

                      
                      Text(
                        isSell ? "Posted by" : "Requested by",
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
                            backgroundImage: model.user?.profilePicture != null
                                ? CachedNetworkImageProvider(
                                    model.user!.profilePicture!,
                                    maxWidth: 120,
                                    maxHeight: 120,
                                  )
                                : null,
                            child: model.user?.profilePicture == null
                                ? Icon(Icons.person, color: OColor.gray600)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.user?.name?.toString() ?? "N/A",
                                style: OTextStyle.labelMedium.copyWith(
                                  color: OColor.gray800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                model.user?.email?.toString() ?? "N/A",
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
                            child: _DetailActionButton(
                              icon: FluentIcons.edit_24_regular,
                              label: "Edit Ad",
                              color: OColor.green600,
                              onTap: () async {
                                Navigator.pop(context);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SellItemForm(
                                      type: isSell ? "Sell" : "Buy",
                                      existingItem: model,
                                    ),
                                  ),
                                );
                                // Refresh if needed
                                if (result == true && context.mounted) {
                                  // You can add refresh logic here
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DetailActionButton(
                              icon: FluentIcons.delete_24_regular,
                              label: "Delete Ad",
                              color: OColor.red600,
                              onTap: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(context);
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSell ? 'Delete Ad' : 'Delete Request'),
        content: Text('Are you sure you want to delete this ${isSell ? 'ad' : 'request'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: OColor.red600)),
          ),
        ],
      ),
    );
  }
}

/// ---------------- DETAIL ACTION BUTTON ----------------

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DetailActionButton({
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
            border: Border.all(color: color, width: 1.5),
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