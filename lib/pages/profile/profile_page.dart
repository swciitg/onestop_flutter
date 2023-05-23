import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/pages/profile/edit_profile.dart';
import 'package:onestop_dev/widgets/profile/data_tile.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../models/profile/profile_model.dart';

class Profile extends StatefulWidget {
  final ProfileModel? profileModel;
  const Profile({super.key, this.profileModel});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        iconTheme: const IconThemeData(color: kAppBarGrey),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "Profile",
          textAlign: TextAlign.left,
          style: MyFonts.w500.size(23).setColor(kWhite),

        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12,),
              Center(child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(75)),color: kWhite2),
                    child: Image.asset('assets/images/class.png',fit: BoxFit.fill,),
                    
                  ),
      
                ]
              )),
              const SizedBox(height: 24,),
              Text('Basic Information',
                  style: MyFonts.w600.size(16).setColor(kWhite)),
              const SizedBox(
                height: 6,
              ),
              DataTile(title: 'Username',semiTitle: widget.profileModel?.username,),
              DataTile(title: 'Roll Number',semiTitle: widget.profileModel?.rollNumber,),
              DataTile(title: 'Outlook ID',semiTitle: widget.profileModel?.outlook,),
              DataTile(title: 'Gmail',semiTitle: widget.profileModel?.gmail,),
              DataTile(title: 'Contact Number',semiTitle: widget.profileModel?.contact,),
              DataTile(title: 'Emergency Contact Number',semiTitle: widget.profileModel?.emergencyContact,),
              DataTile(title: 'Hostel',semiTitle: widget.profileModel?.hostel,),
              widget.profileModel==null?Container(): DataTile(title: 'Date of Birth',semiTitle: DateFormat('dd-MMM-yyyy')
                                    .format(widget.profileModel!.date!),),
              DataTile(title: 'LinkedIn Profile',semiTitle: widget.profileModel?.linkedin,),
              SizedBox(height: 24,)
            ],
          ),
        )),
      ),
      floatingActionButton: GestureDetector(
                  onTap: ((){
                    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProfile(profileModel: widget.profileModel,)));
                  }),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)),color: lBlue2),
                    child: const Icon(Icons.edit_outlined),
                  ),
                ),
    );
  }
}