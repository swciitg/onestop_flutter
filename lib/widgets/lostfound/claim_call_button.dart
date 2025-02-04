import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/repository/lnf_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';

class ClaimCallButton extends StatefulWidget {
  final dynamic model;
  final BuildContext parentContext;

  const ClaimCallButton(
      {Key? key, required this.model, required this.parentContext})
      : super(key: key);

  @override
  State<ClaimCallButton> createState() => _ClaimCallButtonState();
}

class _ClaimCallButtonState extends State<ClaimCallButton> {
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.model is FoundModel) {
          if (widget.model.claimed == true) {
            return;
          }
          showDialog(
              context: context,
              builder: (BuildContext claimDialogContext) {
                return AlertDialog(
                    title: const Text("Are you sure to claim this item ?"),
                    content: ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (buttonPressed == true) {
                                return;
                              }
                              buttonPressed = true;
                              var name = LoginStore.userData['name'];
                              var email = LoginStore.userData['outlookEmail'];
                              var body = await LnfRepository().claimFoundItem(
                                  name: name!,
                                  email: email!,
                                  id: widget.model.id);

                              buttonPressed = false;
                              if (!mounted) return;
                              if (body["saved"] == false) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  body["message"],
                                  style: MyFonts.w500,
                                )));
                                Navigator.popUntil(context,
                                    ModalRoute.withName(LostFoundHome.id));
                              } else {
                                widget.model.claimed = true;
                                widget.model.claimerEmail =
                                    LoginStore.userData["outlookEmail"]!;
                                Navigator.popUntil(context,
                                    ModalRoute.withName(LostFoundHome.id));
                                ScaffoldMessenger.of(widget.parentContext)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Claimed Item Successfully",
                                  style: MyFonts.w500,
                                )));
                              }
                            },
                            child: Text(
                              "YES",
                              style: MyFonts.w600.size(17),
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
                              style: MyFonts.w600.size(17),
                            ),
                          )
                        ],
                      ),
                    ));
              });
        } else {
          try {
            await launchPhoneURL(widget.model.phonenumber);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              color: kGrey9, borderRadius: BorderRadius.circular(24)),
          alignment: Alignment.center,
          child: (widget.model is FoundModel)
              ? (widget.model.claimed == false
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FluentIcons.hand_left_24_filled,
                          size: 11,
                          color: lBlue2,
                        ),
                        Text(
                          " Claim",
                          style: MyFonts.w500.size(11).setColor(lBlue2),
                        )
                      ],
                    )
                  : Text(
                      widget.model.claimerEmail ==
                              LoginStore.userData["outlookEmail"]
                          ? " You claimed"
                          : " Already Claimed",
                      style: MyFonts.w500.size(11).setColor(lBlue2),
                    ))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FluentIcons.call_24_filled,
                      size: 11,
                      color: lBlue2,
                    ),
                    Text(
                      " Call",
                      style: MyFonts.w500.size(11).setColor(lBlue2),
                    )
                  ],
                )),
    );
  }
}
