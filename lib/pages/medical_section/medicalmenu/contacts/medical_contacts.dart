import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contactpagebutton.dart';
import 'package:onestop_kit/onestop_kit.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(
            child: FutureBuilder<List<List<MedicalcontactModel>>>(
                future: DataProvider.getMedicalContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<List<MedicalcontactModel>> medicalContacts =
                        snapshot.data as List<List<MedicalcontactModel>>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 16,
                                child: Container(),
                              ),
                              MedicalContactPageButton(
                                label: 'Doctors',
                                labelContacts: medicalContacts[0],
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(),
                              ),
                              MedicalContactPageButton(
                                label: "Visiting Consultants",
                                labelContacts: medicalContacts[1],
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(),
                              ),
                              MedicalContactPageButton(
                                label: 'miscellaneous',
                                labelContacts: medicalContacts[2],
                              ),
                              Expanded(
                                flex: 16,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
          ),
        ),
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
