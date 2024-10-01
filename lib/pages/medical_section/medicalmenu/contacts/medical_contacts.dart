import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/medicalcontacts/allmedicalcontacts.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contact_dialog.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contactpagebutton.dart';
import 'package:onestop_kit/onestop_kit.dart';
import '../../../../globals/my_fonts.dart';

class MedicalContacts extends StatefulWidget {
  const MedicalContacts({super.key});

  @override
  State<MedicalContacts> createState() => _MedicalContactsState();
}

class _MedicalContactsState extends State<MedicalContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 30, 1),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: FutureBuilder<Allmedicalcontacts?>(
            future: DataProvider.getMedicalContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Allmedicalcontacts medicalAPIContacts =
                    snapshot.data as Allmedicalcontacts;
                List<List<MedicalcontactModel>> medicalContacts = [[], [], []];
                for (var element in medicalAPIContacts.alldoctors) {
                  if (element.category == 'Permanent Doctors') {
                    medicalContacts[0].add(element);
                  } else if (element.category == 'Visiting Consultant') {
                    medicalContacts[1].add(element);
                  } else {
                    medicalContacts[2].add(element); // Miscelleneous
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 16,
                            child: Container(),
                          ),
                          MedicalContactPageButton(
                            label: 'Institute Doctors',
                            labelContacts: medicalContacts[0],
                            icon: const Icon(
                              FluentIcons.person_home_28_filled,
                              color: kGrey8,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(),
                          ),
                          MedicalContactPageButton(
                            label: "Visiting Doctors",
                            labelContacts: medicalContacts[1],
                            icon: const Icon(
                              FluentIcons.person_accounts_24_filled,
                              color: kGrey8,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(),
                          ),
                          MedicalContactPageButton(
                            label: 'Reception & Support',
                            labelContacts: medicalContacts[2],
                            icon: const Icon(
                              Icons.people_outlined,
                              color: kGrey8,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 16,
                            child: Container(),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Institute Doctors",
                          style: MyFonts.w700
                              .setColor(kWhite)
                              .size(14)
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 16)),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildContactList(medicalContacts[0]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Visiting Doctors",
                        style: MyFonts.w700.setColor(kWhite).size(14).copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildContactList(medicalContacts[1]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Reception & Support Contacts",
                          style: MyFonts.w700
                              .setColor(kWhite)
                              .size(14)
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 16)),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildContactList(medicalContacts[2]),
                    ],
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kAppBarGrey,
    iconTheme: const IconThemeData(color: kAppBarGrey),
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      "Medical Contacts",
      textAlign: TextAlign.center,
      style: OnestopFonts.w500.size(20).setColor(kWhite),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.clear,
          color: kWhite,
        ),
      ),
    ],
  );
}

Widget _buildContactList(List<MedicalcontactModel> medList) {
  return ListView.builder(
      itemCount: medList.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => MedicalContactDialog(contact: medList[index]),
                barrierDismissible: true);
          },
          child: Card(
            color: const Color.fromRGBO(28, 28, 30, 1), // Dark background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medList[index].name.name!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color for dark mode
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medList[index].designation!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey, // Grey text color for phone number
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
