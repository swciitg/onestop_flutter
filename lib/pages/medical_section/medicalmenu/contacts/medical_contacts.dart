import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/contacts/contact_model.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';
import 'package:onestop_dev/services/data_provider.dart';
import 'package:onestop_dev/widgets/medicalsection/medical_contactpagebutton.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../functions/utility/phone_email.dart';
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
        child: FutureBuilder<List<List<MedicalcontactModel>>>(
            future: DataProvider.getMedicalContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<List<MedicalcontactModel>> medicalContacts =
                    snapshot.data as List<List<MedicalcontactModel>>;
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
                            labelContacts: medicalContacts[0], icon: Icon(FluentIcons.person_home_28_filled,color: kGrey8,size: 30,),
                          ),

                          SizedBox(width:10),

                          MedicalContactPageButton(
                            label: "Visiting Doctors",
                            labelContacts: medicalContacts[1], icon: Icon(FluentIcons.person_accounts_24_filled,color: kGrey8,size: 30,),
                          ),

                          SizedBox(width:10),

                          MedicalContactPageButton(
                            label: 'Reception & Support',
                            labelContacts: medicalContacts[2], icon: const Icon(Icons.people_outlined, color: kGrey8,size: 30,),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10,),
                      Text("Institute Doctors",
                          style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 16)
                      ),
                      SizedBox(height: 10,),
                      _buildContactList(medicalContacts[0]),
                      SizedBox(height: 10,),
                      Text("Visiting Doctors",style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 16),),
                      SizedBox(height: 10,),
                      _buildContactList(medicalContacts[1]),
                      SizedBox(height: 10,),
                      Text("Reception & Support Contacts",style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 16)),
                      SizedBox(height: 10,),
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

void _showContactInfoDialog(BuildContext context, MedicalcontactModel contact) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        backgroundColor: Colors.grey[900], // Dark background
        content: Container(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.name,
                  style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10,),
                _buildInfoRow(Icons.work, contact.designation),
                _buildInfoRow(Icons.school, contact.degree),
                _buildInfoRow(Icons.phone, "0361258${contact.phone}"),
                _buildInfoRow(Icons.email, contact.email),
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
                  IconButton(onPressed: () async {
                    try {
                      await _launchPhoneURL("0361258${contact.phone}");
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }

                  }, icon: Icon(Icons.call, color: Colors.green),),
                  IconButton(onPressed: () async {
                    try {
                      await launchEmailURL(contact.email);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }, icon: Icon(Icons.mail, color: Colors.blue),),
                ],
              ),
              TextButton(
                child: Text("Close", style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 16)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildInfoRow(IconData icon, String info) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20), // Icon only
        SizedBox(width: 8),
        Expanded(
          child: Text(
            info,
            style: MyFonts.w700.setColor(kWhite).size(14).copyWith(fontWeight: FontWeight.w500,color: Colors.white70,fontSize: 15),
            //style: TextStyle(color: Colors.white70, fontSize: 15), // Just data, no label
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildContactList(List<MedicalcontactModel> medList){
  return ListView.builder(
      itemCount: medList.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context,index){
        return InkWell(
          onTap: (){
            _showContactInfoDialog(context,medList[index]);
          },
          child: Card(
            color: const Color(0xFF1E1E1E), // Dark background color
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
                    medList[index].name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color for dark mode
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medList[index].designation,
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
      }
  );
}

_launchPhoneURL(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}