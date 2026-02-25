import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/phone_email.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_ui/index.dart';

class MedicalContactDialog extends StatefulWidget {
  final MedicalcontactModel contact;
  final bool isMisc;
  const MedicalContactDialog({super.key, required this.contact, required this.isMisc});

  @override
  State<MedicalContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<MedicalContactDialog> {
  bool isStarred = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber = "361258${widget.contact.phone}";
    var name = widget.isMisc ? widget.contact.miscellaneousContact! : widget.contact.name.name!;
    if (!widget.isMisc) {
      return AlertDialog(
        backgroundColor: OColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: OSpacing.s),
                _buildInfoRow(Icons.work, widget.contact.name.designation!),
                _buildInfoRow(Icons.school, widget.contact.name.degree!),
                _buildInfoRow(Icons.phone, "361258${widget.contact.phone}"),
                _buildInfoRow(Icons.email, widget.contact.email!),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      try {
                        await launchPhoneURL(phoneNumber);
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    icon: Icon(Icons.call, color: OColor.green600),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await launchEmailURL(widget.contact.email ?? "");
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    icon: Icon(Icons.mail, color: OColor.blue500),
                  ),
                ],
              ),
              TextButton(
                child: Text("Close", style: OTextStyle.bodySmall.copyWith(color: OColor.gray600)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return AlertDialog(
        backgroundColor: OColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: OSpacing.s),
                _buildInfoRow(Icons.phone, "361258${widget.contact.phone}"),
                _buildInfoRow(Icons.email, widget.contact.email!),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      try {
                        await launchPhoneURL(phoneNumber);
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    icon: Icon(Icons.call, color: OColor.green600),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await launchEmailURL(widget.contact.email ?? "");
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    icon: Icon(Icons.mail, color: OColor.blue500),
                  ),
                ],
              ),
              TextButton(
                child: Text("Close", style: OTextStyle.bodySmall.copyWith(color: OColor.gray600)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    }
  }
}

Widget _buildInfoRow(IconData icon, String info) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: OSpacing.xxs),
    child: Row(
      children: [
        Icon(icon, color: OColor.gray400, size: 20),
        const SizedBox(width: OSpacing.xs),
        Expanded(
          child: Text(
            info,
            style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
