import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contact_dialog.dart';
import 'package:onestop_ui/index.dart';

class MedicalContactdetails extends StatefulWidget {
  final String title;
  final List<MedicalcontactModel> contacts;

  const MedicalContactdetails({super.key, required this.contacts, required this.title});

  @override
  State<MedicalContactdetails> createState() => _MedicalContactdetailsState();
}

class _MedicalContactdetailsState extends State<MedicalContactdetails> {
  @override
  Widget build(BuildContext context) {
    bool isMisc = widget.title == 'Reception & Support';
    return SafeArea(
      child: Scaffold(
        backgroundColor: OColor.gray100,
        appBar: AppBar(
          backgroundColor: OColor.gray100,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: IconButton(
            icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Contacts', style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: OSpacing.l),
              Text(widget.title, style: OTextStyle.labelLarge.copyWith(color: OColor.gray800)),
              const SizedBox(height: OSpacing.xxs),
              Text(
                '${widget.contacts.length} contacts',
                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
              ),
              const SizedBox(height: OSpacing.m),
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(vertical: OSpacing.xs, horizontal: OSpacing.s),
                decoration: BoxDecoration(
                  color: OColor.gray200,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Name',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Email',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Phone',
                        style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: OSpacing.xs),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.contacts.length,
                  separatorBuilder: (_, _) => Divider(color: OColor.gray200, height: 1),
                  itemBuilder: (context, index) {
                    final item = widget.contacts[index];
                    var name = isMisc ? item.miscellaneousContact : item.name.name;
                    return InkWell(
                      borderRadius: BorderRadius.circular(OCornerRadius.s),
                      onTap: () {
                        showMedicalContactSheet(context, contact: item, isMisc: isMisc);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: OSpacing.s,
                          horizontal: OSpacing.s,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                name ?? '',
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.email ?? '',
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "361258${item.phone.toString()}",
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
