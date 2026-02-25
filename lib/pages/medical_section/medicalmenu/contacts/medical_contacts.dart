import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/models/medicalcontacts/allmedicalcontacts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/services/data_service.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contact_dialog.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contactpagebutton.dart';
import 'package:onestop_ui/index.dart';

class MedicalContacts extends StatefulWidget {
  const MedicalContacts({super.key});

  @override
  State<MedicalContacts> createState() => _MedicalContactsState();
}

class _MedicalContactsState extends State<MedicalContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'Medical Contacts',
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: OSpacing.xl, horizontal: OSpacing.xs),
        child: FutureBuilder<Allmedicalcontacts?>(
          future: DataService.getMedicalContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Allmedicalcontacts medicalAPIContacts = snapshot.data as Allmedicalcontacts;
              List<List<MedicalcontactModel>> medicalContacts = [[], [], []];
              for (var element in medicalAPIContacts.alldoctors) {
                if (element.category == 'Permanent Doctors') {
                  medicalContacts[0].add(element);
                } else if (element.category == 'Visiting Consultant') {
                  medicalContacts[1].add(element);
                } else {
                  medicalContacts[2].add(element);
                }
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 16, child: Container()),
                        MedicalContactPageButton(
                          label: 'Institute Doctors',
                          labelContacts: medicalContacts[0],
                          icon: Icon(
                            FluentIcons.person_home_28_filled,
                            color: OColor.green600,
                            size: 30,
                          ),
                        ),
                        Expanded(flex: 5, child: Container()),
                        MedicalContactPageButton(
                          label: "Visiting Doctors",
                          labelContacts: medicalContacts[1],
                          icon: Icon(
                            FluentIcons.person_accounts_24_filled,
                            color: OColor.green600,
                            size: 30,
                          ),
                        ),
                        Expanded(flex: 5, child: Container()),
                        MedicalContactPageButton(
                          label: 'Reception & Support',
                          labelContacts: medicalContacts[2],
                          icon: Icon(Icons.people_outlined, color: OColor.green600, size: 30),
                        ),
                        Expanded(flex: 16, child: Container()),
                      ],
                    ),
                    Divider(color: OColor.gray200),
                    const SizedBox(height: OSpacing.xs),
                    Text(
                      "Institute Doctors",
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.xs),
                    _buildContactList(medicalContacts[0]),
                    const SizedBox(height: OSpacing.xs),
                    Text(
                      "Visiting Doctors",
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.xs),
                    _buildContactList(medicalContacts[1]),
                    const SizedBox(height: OSpacing.xs),
                    Text(
                      "Reception & Support Contacts",
                      style: OTextStyle.labelSmall.copyWith(color: OColor.gray600),
                    ),
                    const SizedBox(height: OSpacing.xs),
                    _buildContactList(medicalContacts[2]),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

Widget _buildContactList(List<MedicalcontactModel> medList) {
  return ListView.builder(
    itemCount: medList.length,
    shrinkWrap: true,
    primary: false,
    itemBuilder: (context, index) {
      bool isMisc = medList[index].miscellaneousContact.toString().isNotEmpty;
      var name = isMisc ? medList[index].miscellaneousContact : medList[index].name.name;
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => MedicalContactDialog(contact: medList[index], isMisc: isMisc),
            barrierDismissible: true,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: OSpacing.xs),
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: BorderRadius.circular(OCornerRadius.m),
            border: Border.all(color: OColor.gray200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(OSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name!, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                const SizedBox(height: OSpacing.xs),
                isMisc
                    ? const SizedBox.shrink()
                    : Text(
                      medList[index].name.designation!,
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                    ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
