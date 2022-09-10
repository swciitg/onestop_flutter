import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/pages/contact/contact_detail.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/stores/contact_store.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    return FutureBuilder<SplayTreeMap<String, ContactModel>>(
      future: DataProvider.getContacts(),
      builder: (BuildContext context, snapshot) {
        if(!snapshot.hasData)
         {
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
         }
        SplayTreeMap<String, ContactModel> people = snapshot.data!;
        return Expanded(
          flex: 106,
          child: GestureDetector(
            onTap: () {
              var contact = people['Gymkhana'];
              if(widget.label == "Emergency")
              {
                contact = people['Emergency'];
              }
              else if(widget.label == 'Transport')
              {
                contact = people['Transport'];
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
      },
    );
  }
}
