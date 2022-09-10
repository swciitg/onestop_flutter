import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/contact/contact_data.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:provider/provider.dart';

class ContactPageButton extends StatefulWidget {
  final String label;
  final ContactStore store;
  const ContactPageButton({Key? key, required this.label, required this.store}) : super(key: key);

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
          var contact = gymkhana;
          if(widget.label == "Emergency")
            {
              contact = emergency;
            }
          else if(widget.label == 'Transport')
            {
              contact = travel;
            }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return Provider<ContactStore>.value(
                  value: widget.store,
                  child: ContactDetailsPage(
                    contact: contact,
                      title: 'Campus'),
                );
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
