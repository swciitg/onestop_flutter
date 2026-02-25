import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_ui/index.dart';

import 'details_dialog.dart';

class BuyTile extends StatelessWidget {
  const BuyTile({
    super.key,
    required this.model,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
  });

  final dynamic model;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isNew = model.isNew == true;

    return GestureDetector(
      onTap: () {
        detailsDialogBox(context, model);
      },
      child: Container(
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    model.imageURL,
                    fit: BoxFit.cover,
                    cacheWidth: 200,
                    frameBuilder: restaurantTileFrameBuilder,
                    errorBuilder:
                        (_, _, _) => Container(
                          color: OColor.gray200,
                          child: Icon(Icons.image_outlined, color: OColor.gray400, size: 40),
                        ),
                  ),
                  if (isNew)
                    Positioned(
                      left: OSpacing.xs,
                      bottom: OSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.xs,
                          vertical: OSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: OColor.blue100,
                          borderRadius: BorderRadius.circular(OCornerRadius.xl),
                        ),
                        child: Text(
                          'BRAND NEW',
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.blue500,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.s, vertical: OSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: OTextStyle.labelSmall.copyWith(color: OColor.gray800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  Text(
                    '\u{20B9}${model.price}',
                    style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                  ),
                  if (showActions) ...[
                    const SizedBox(height: OSpacing.xs),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onEdit,
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
                          onTap: onDelete,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
