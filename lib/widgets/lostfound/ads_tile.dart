import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/buy_sell/details_dialog.dart';

import '../../functions/utility/auth_user_helper.dart';
import '../../globals/endpoints.dart';

class MyAdsTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final model;
  const MyAdsTile({Key? key, this.model}) : super(key: key);

  @override
  State<MyAdsTile> createState() => _MyAdsTileState();
}

class _MyAdsTileState extends State<MyAdsTile> {
  bool isOverlay = false;
  @override
  Widget build(BuildContext context) {
    bool isLnf = (widget.model is FoundModel) || (widget.model is LostModel);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            detailsDialogBox(context, widget.model);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: kBlueGrey,
              ),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isOverlay = true;
                                      });
                                    },
                                    child: const Icon(
                                      FluentIcons.more_vertical_28_filled,
                                      size: 15,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    widget.model.title,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        MyFonts.w600.size(16).setColor(kWhite),
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
                                    style:
                                        MyFonts.w500.size(12).setColor(kGrey6),
                                  ),
                                ),
                                isLnf
                                    ? Container()
                                    : Expanded(
                                        child: Text(
                                          '\u{20B9}${widget.model.price}/-',
                                          style: MyFonts.w600
                                              .size(14)
                                              .setColor(lBlue4),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: AuthUserHelpers.getAccessToken(),
                    builder: (context, snapshot) {
                      if(snapshot.hasError || !snapshot.hasData)
                      {
                        return Container();
                      }
                      return Expanded(
                        flex: 4,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(21),
                              bottomRight: Radius.circular(21)),
                          child: Image.network(widget.model.imageURL,
                              cacheWidth: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(),
                              headers: {'Content-Type': 'application/json', 'security-key': Endpoints.apiSecurityKey, 'Authorization': "Bearer ${snapshot.data}"},
                              frameBuilder: restaurantTileFrameBuilder),
                        ),
                      );
                    }
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
              child: Container(
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  color: Colors.black.withOpacity(0.74),
                ),
              ),
            ),
          ),
        if (isOverlay)
          Positioned(
            top: 20,
            left: 30 + 14, // Adding the tile padding
            child: Container(
              height: 33,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: lBlue2,
              ),
              child: TextButton(
                child: Text(
                  "Delete",
                  style: MyFonts.w400.size(14).setColor(kBlack),
                ),
                onPressed: () async {
                  if (isLnf) {
                    await APIService().deleteLnfMyAd(
                        widget.model.id, widget.model.email);
                  } else {
                    await APIService().deleteBnsMyAd(
                        widget.model.id, widget.model.email);
                  }

                  if (!mounted) return;
                  Navigator.of(context).pop();
                  showSnackBar("Deleted your post successfully");
                },
              ),
            ),
          ),
      ],
    );
  }
}
