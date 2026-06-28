import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';
import 'package:onestop_ui/index.dart';

class MyAdsTile extends StatefulWidget {
  final dynamic model;

  const MyAdsTile({super.key, this.model});

  @override
  State<MyAdsTile> createState() => _MyAdsTileState();
}

class _MyAdsTileState extends State<MyAdsTile> {
  bool isOverlay = false;

  @override
  Widget build(BuildContext context) {
    bool isLnf = (widget.model is FoundModel) || (widget.model is LostModel);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GestureDetector(
          onTap: () {
            detailsDialogBox(context, widget.model);
          },
          child: Container(
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: BorderRadius.circular(OCornerRadius.s),
              border: Border.all(color: OColor.gray200),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.model.imageURL,
                    cacheWidth: 200,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, _, _) => Container(
                          color: OColor.gray200,
                          child: Icon(Icons.image_outlined, color: OColor.gray400, size: 40),
                        ),
                    frameBuilder: restaurantTileFrameBuilder,
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OSpacing.s,
                    vertical: OSpacing.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.title,
                        overflow: TextOverflow.ellipsis,
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                        maxLines: 1,
                      ),
                      if (isLnf)
                        Text(
                          "${(widget.model is FoundModel) ? "Found at: " : "Lost at: "}${widget.model.location}",
                          overflow: TextOverflow.ellipsis,
                          style: OTextStyle.bodySmall.copyWith(color: OColor.gray600, fontSize: 12),
                          maxLines: 1,
                        )
                      else ...[
                        const SizedBox(height: OSpacing.xxs),
                        Text(
                          '\u{20B9}${widget.model.price}',
                          style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                        ),
                      ],
                      const SizedBox(height: OSpacing.xs),
                      // Edit / Delete actions
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Edit - currently opens details
                              detailsDialogBox(context, widget.model);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 14, color: OColor.green600),
                                const SizedBox(width: 4),
                                Text(
                                  'Edit',
                                  style: OTextStyle.bodySmall.copyWith(
                                    color: OColor.green600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: OSpacing.m),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isOverlay = true;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 14, color: OColor.red500),
                                const SizedBox(width: 4),
                                Text(
                                  'Delete',
                                  style: OTextStyle.bodySmall.copyWith(
                                    color: OColor.red500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
        ),
        // Delete confirmation overlay
        if (isOverlay)
          GestureDetector(
            onTap: () {
              setState(() {
                isOverlay = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(OCornerRadius.s),
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
        if (isOverlay)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.xs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OCornerRadius.m),
              color: OColor.red500,
            ),
            child: TextButton(
              child: Text(
                "Confirm Delete",
                style: OTextStyle.labelSmall.copyWith(color: OColor.white),
              ),
              onPressed: () async {
                if (isLnf) {
                  await LnfRepository().deleteLnfMyAd(widget.model.id, widget.model.email);
                } else {
                  await BnsRepository().deleteBnsMyAd(widget.model.id, widget.model.email);
                }

                if (!mounted) return;
                Navigator.of(context).pop();
                showSnackBar("Deleted your post successfully");
              },
            ),
          ),
      ],
    );
  }
}
