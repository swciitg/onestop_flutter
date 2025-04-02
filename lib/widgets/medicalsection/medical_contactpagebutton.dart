import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/pages/medical_section/medicalmenu/contacts/medical_contactdetails.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:shimmer/shimmer.dart';

class MedicalContactPageButton extends StatefulWidget {

  final String label;
  final List<MedicalcontactModel> labelContacts;
  final Icon icon;

  const MedicalContactPageButton(
      {super.key, required this.label, required this.labelContacts, required this.icon});

  @override
  State<MedicalContactPageButton> createState() =>
      _MedicalContactPageButtonState();
}

class _MedicalContactPageButtonState extends State<MedicalContactPageButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.labelContacts.isEmpty) {
      return Expanded(
        flex: 106,
        child: Shimmer.fromColors(
          highlightColor: lGrey,
          baseColor: kHomeTile,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: lGrey,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MedicalContactdetails(
                  contacts: widget.labelContacts, title: widget.label);
            }));
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: lGrey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                const SizedBox(height: 3),
                Text(
                  widget.label,
                  style: MyFonts.w600.size(9).setColor(kWhite),
                   overflow:TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
