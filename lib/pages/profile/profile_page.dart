import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../globals/my_colors.dart';
import '../../globals/my_fonts.dart';
import '../../models/profile/profile_model.dart';
import '../../stores/login_store.dart';
import '../../widgets/profile/data_tile.dart';
import '../../widgets/profile/feedback.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final ProfileModel profileModel;
  const Profile({super.key, required this.profileModel});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print(widget.profileModel!.toJson());
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        iconTheme: const IconThemeData(color: kAppBarGrey),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: 16,
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        },icon: Icon(Icons.arrow_back_ios_new_outlined,color: kWhite,),iconSize: 20,),
        title: Text(
          "Profile",
          textAlign: TextAlign.left,
          style: MyFonts.w500.size(23).setColor(kWhite),
        ),
        actions: [
          if (!context.read<LoginStore>().isGuestUser)
            IconButton(
                onPressed: (() {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const FeedBack();
                      });
                }),
                icon: const Icon(
                  Icons.bug_report_outlined,
                  color: kWhite,
                )),
          IconButton(
              onPressed: (() {
                context.read<LoginStore>().logOut(() => Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false));
              }),
              icon: const Icon(
                Icons.logout_outlined,
                color: kWhite,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              // Center(
              //     child: Stack(alignment: Alignment.bottomRight, children: [
              //   ClipRRect(
              //       borderRadius: BorderRadius.circular(75.0),
              //       child: Image(
              //         image: widget.profileModel?.image == null
              //             ? const ResizeImage(
              //                 AssetImage(
              //                     'assets/images/profile_placeholder.png'),
              //                 width: 150,
              //                 height: 150)
              //             : ResizeImage(
              //                 MemoryImage(
              //                     base64Decode(widget.profileModel!.image!)),
              //                 width: 150,
              //                 height: 150,
              //               ),
              //         fit: BoxFit.fill,
              //       )),
              // ])),
              // const SizedBox(
              //   height: 24,
              // ),
              Text('Basic Information',
                  style: MyFonts.w600.size(16).setColor(kWhite)),
              const SizedBox(
                height: 6,
              ),
              DataTile(
                title: 'Username',
                semiTitle: widget.profileModel.name,
              ),
              DataTile(
                title: 'Roll Number',
                semiTitle: widget.profileModel.rollNo,
              ),
              DataTile(
                title: 'Outlook ID',
                semiTitle: widget.profileModel.outlookEmail,
              ),
              DataTile(
                title: 'Alt Email',
                semiTitle: widget.profileModel.altEmail,
              ),
              DataTile(
                title: 'Contact Number',
                semiTitle: widget.profileModel.phoneNumber!=null ? widget.profileModel.phoneNumber.toString() : null,
              ),
              DataTile(
                title: 'Emergency Contact Number',
                semiTitle: widget.profileModel.emergencyPhoneNumber!=null ? widget.profileModel.emergencyPhoneNumber.toString() : null,
              ),
              DataTile(
                title: 'Hostel',
                semiTitle: widget.profileModel.hostel,
              ),
              widget.profileModel.dob==null
                  ? Container()
                  : DataTile(
                      title: 'Date of Birth',
                      semiTitle: DateFormat('dd-MMM-yyyy')
                          .format(DateTime.parse(widget.profileModel.dob!)),
                    ),
              DataTile(
                title: 'LinkedIn Profile',
                semiTitle: widget.profileModel.linkedin,
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        )),
      ),
      floatingActionButton: LoginStore.isGuest ? Container() : GestureDetector(
        onTap: (() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditProfile(
                    profileModel: widget.profileModel,
                  )));
        }),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: lBlue2),
          child: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}
