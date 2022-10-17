import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

class LostFoundTile extends StatefulWidget {
  final dynamic currentModel;
  final BuildContext? parentContext;
  const LostFoundTile(
      {Key? key, required this.currentModel, this.parentContext})
      : super(key: key);

  @override
  State<LostFoundTile> createState() => _LostFoundTileState();
}

class _LostFoundTileState extends State<LostFoundTile> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Duration passedDuration =
        DateTime.now().difference(widget.currentModel.date);
    String timeagoString =
        timeago.format(DateTime.now().subtract(passedDuration));

    return GestureDetector(
      onTap: () {
        if (widget.parentContext != null) {
          detailsDialogBox(context, widget.currentModel, widget.parentContext!);
        } else {
          detailsDialogBox(context, widget.currentModel);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
            color: kBlueGrey, borderRadius: BorderRadius.circular(21)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 194),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 5),
                      child: Text(
                        widget.currentModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w500.size(16).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "${(widget.currentModel.runtimeType == FoundModel)?"Found":"Lost"} at: ${widget.currentModel.location}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w300.size(14).setColor(kWhite),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 2.5),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: kGrey9,
                          borderRadius: BorderRadius.circular(41)),
                      child: Text(
                        timeagoString,
                        style: MyFonts.w500.size(12).setColor(lBlue2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 105, maxWidth: 135),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21)),
                child: Image.network(
                  widget.currentModel.compressedImageURL,
                  width: screenWidth * 0.35,
                  cacheWidth: (screenWidth * 0.35).round(),
                  fit: BoxFit.cover,
                  frameBuilder: restaurantTileFrameBuilder,
                  errorBuilder: (_, __, ___) => Container(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
