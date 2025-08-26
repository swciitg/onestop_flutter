import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MyAdsTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            child: Container(
              height: 115,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), color: kBlueGrey),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 2.0, 3.0, 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.model.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyFonts.w600.size(16).setColor(kWhite),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isOverlay = true;
                                    });
                                  },
                                  icon: const Icon(
                                    FluentIcons.more_vertical_28_filled,
                                    size: 15,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    isLnf
                                        ? (((widget.model is FoundModel)
                                                ? "Found at: "
                                                : "Lost at: ") +
                                            widget.model.location)
                                        : widget.model.description,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyFonts.w500.size(12).setColor(kGrey6),
                                  ),
                                ),
                                isLnf
                                    ? Container()
                                    : Expanded(
                                      child: Text(
                                        '\u{20B9}${widget.model.price}/-',
                                        style: MyFonts.w600.size(14).setColor(lBlue4),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(21),
                        bottomRight: Radius.circular(21),
                      ),
                      child: Image.network(
                        widget.model.imageURL,
                        cacheWidth: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(),
                        frameBuilder: restaurantTileFrameBuilder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isOverlay)
          GestureDetector(
            onTap: () {
              setState(() {
                isOverlay = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
              child: Container(
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: Colors.black.withValues(alpha: 0.74),
                ),
              ),
            ),
          ),
        if (isOverlay)
          Container(
            height: 33,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: lBlue2),
            child: TextButton(
              child: Text("Delete", style: MyFonts.w400.size(14).setColor(kBlack)),
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
