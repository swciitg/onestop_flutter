import 'package:flutter/material.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/contacts/medical_contactdetails.dart';
import 'package:onestop_ui/index.dart';
import 'package:shimmer/shimmer.dart';

class MedicalContactPageButton extends StatefulWidget {
  final String label;
  final List<MedicalcontactModel> labelContacts;
  final Icon icon;

  const MedicalContactPageButton({
    super.key,
    required this.label,
    required this.labelContacts,
    required this.icon,
  });

  @override
  State<MedicalContactPageButton> createState() => _MedicalContactPageButtonState();
}

class _MedicalContactPageButtonState extends State<MedicalContactPageButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.labelContacts.isEmpty) {
      return Expanded(
        flex: 106,
        child: Shimmer.fromColors(
          highlightColor: OColor.gray200,
          baseColor: OColor.gray100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OCornerRadius.l),
              color: OColor.gray200,
            ),
            height: 100,
          ),
        ),
      );
    } else {
      return Expanded(
        flex: 106,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MedicalContactdetails(contacts: widget.labelContacts, title: widget.label);
                },
              ),
            );
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(OCornerRadius.l),
              color: OColor.white,
              border: Border.all(color: OColor.gray200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                const SizedBox(height: 3),
                Text(
                  widget.label,
                  style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray800),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
