import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class ContactPageButton extends StatefulWidget {
  final String label;
  final BuildContext context;
  const ContactPageButton({Key? key, required this.label, required this.context}) : super(key: key);

  @override
  State<ContactPageButton> createState() => _ContactPageButtonState();
}

class _ContactPageButtonState extends State<ContactPageButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 106,
      child: GestureDetector(
        onTap: () {
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
              Icon(
                (widget.label == 'Emergency')
                    ? Icons.warning
                    : (widget.label == 'Transport')
                        ? Icons.directions_bus
                        : Icons.group,
                color: kGrey8,
              ),
              Text(
                widget.label,
                style: MyFonts.w600.size(10).setColor(kWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
