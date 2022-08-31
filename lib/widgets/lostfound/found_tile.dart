import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class FoundItemTile extends StatefulWidget {
  final FoundModel currentFoundModel;
  final BuildContext parentContext;
  const FoundItemTile(
      {Key? key, required this.parentContext, required this.currentFoundModel})
      : super(key: key);

  @override
  State<FoundItemTile> createState() => _FoundItemTileState();
}

class _FoundItemTileState extends State<FoundItemTile> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool buttonPressed = false;
    Duration passedDuration =
        DateTime.now().difference(widget.currentFoundModel.date);
    String timeagoString =
        timeago.format(DateTime.now().subtract(passedDuration));

    void detailsDialogBox(String imageURL, String description, String location,
        String submitted, DateTime date) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 15),
              backgroundColor: kBlueGrey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
                child: Container(
                  decoration: BoxDecoration(
                      color: kBlueGrey,
                      borderRadius: BorderRadius.circular(21)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   width: screenWidth-30,
                      // ), // to match listtile width
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21)),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: screenHeight * 0.3,
                              maxWidth: screenWidth - 30),
                          child: SingleChildScrollView(
                            child: Image.network(
                              imageURL,
                              fit: BoxFit.cover,
                              frameBuilder: restaurantTileFrameBuilder,
                              width: screenWidth - 30,
                              cacheWidth: (screenWidth - 30).round(),
                              errorBuilder: (_, __, ___) => Container(),
                            )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8, top: 10, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                widget.currentFoundModel.title,
                                style: MyFonts.w600.size(16).setColor(kWhite),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (widget.currentFoundModel.claimed == true) {
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (BuildContext claimDialogContext) {
                                      return AlertDialog(
                                          title: const Text(
                                              "Are you sure to claim this item ?"),
                                          content: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxHeight: screenHeight * 0.3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (buttonPressed == true) {
                                                      return;
                                                    }
                                                    buttonPressed = true;
                                                    var name = context
                                                        .read<LoginStore>()
                                                        .userData['name'];
                                                    var email = context
                                                        .read<LoginStore>()
                                                        .userData['email'];

                                                    var body = await APIService
                                                        .claimFoundItem(
                                                            name: name!,
                                                            email: email!,
                                                            id: widget
                                                                .currentFoundModel
                                                                .id);

                                                    buttonPressed = false;
                                                    if (!mounted) return;
                                                    if (body["saved"] ==
                                                        false) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        body["message"],
                                                        style: MyFonts.w500,
                                                      )));
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              LostFoundHome
                                                                  .id));
                                                    } else {
                                                      widget.currentFoundModel
                                                          .claimed = true;
                                                      widget.currentFoundModel
                                                              .claimerEmail =
                                                          context
                                                              .read<
                                                                  LoginStore>()
                                                              .userData["email"]!;
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              LostFoundHome
                                                                  .id));
                                                      ScaffoldMessenger.of(widget
                                                              .parentContext)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "Claimed Item Successfully",
                                                        style: MyFonts.w500,
                                                      )));
                                                    }
                                                  },
                                                  child: Text(
                                                    "YES",
                                                    style:
                                                        MyFonts.w600.size(17),
                                                  ),
                                                ),
                                                Container(
                                                  width: 2.5,
                                                  height: 14,
                                                  color: kBlack,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (buttonPressed == true) {
                                                      return;
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "NO",
                                                    style:
                                                        MyFonts.w600.size(17),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: kGrey9,
                                      borderRadius: BorderRadius.circular(24)),
                                  alignment: Alignment.center,
                                  child:
                                      widget.currentFoundModel.claimed == false
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                              children: [
                                                const Icon(
                                                  Icons.pan_tool,
                                                  size: 11,
                                                  color: lBlue2,
                                                ),
                                                Text(
                                                  " Claim",
                                                  style: MyFonts.w500
                                                      .size(11)
                                                      .setColor(lBlue2),
                                                )
                                              ],
                                            )
                                          : Text(
                                              widget.currentFoundModel
                                                          .claimerEmail ==
                                                      context
                                                          .read<LoginStore>()
                                                          .userData["email"]
                                                  ? " You claimed"
                                                  : " Already Claimed",
                                              style: MyFonts.w500
                                                  .size(11)
                                                  .setColor(lBlue2),
                                            )),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.currentFoundModel.claimed == true
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: screenWidth - 62),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "Claimer: ${widget.currentFoundModel.claimerEmail}",
                                style: MyFonts.w500.size(14).setColor(kGrey6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Submitted at: $submitted",
                          style: MyFonts.w500.size(14).setColor(kGrey6),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        child: Text(
                          "Found at: $location",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: MyFonts.w500.size(14).setColor(kGrey6),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.2,
                            maxWidth: screenWidth - 40),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 13),
                            child: Text(
                              "Description: $description",
                              style: MyFonts.w300.size(14).setColor(kGrey10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 16, bottom: 16),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${date.day}-${date.month}-${date.year} | ${DateFormat.jm().format(date.toLocal())}",
                          style: MyFonts.w300.size(13).setColor(kGrey7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return GestureDetector(
      onTap: () {
        detailsDialogBox(
            widget.currentFoundModel.imageURL,
            widget.currentFoundModel.description,
            widget.currentFoundModel.location,
            widget.currentFoundModel.submittedat,
            widget.currentFoundModel.date);
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
                        widget.currentFoundModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.w500.size(16).setColor(kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Found at: ${widget.currentFoundModel.location}",
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
                  widget.currentFoundModel.compressedImageURL,
                  width: screenWidth * 0.35,
                  cacheWidth: (screenWidth * 0.35).round(),
                  fit: BoxFit.cover,
                  frameBuilder: restaurantTileFrameBuilder,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
