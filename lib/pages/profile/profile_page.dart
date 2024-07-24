import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_kit/onestop_kit.dart';

import '../../globals/my_colors.dart';
import '../../stores/login_store.dart';
import '../../widgets/profile/data_tile.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final OneStopUser profileModel;

  const ProfilePage({super.key, required this.profileModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kAppBarGrey,
        iconTheme: const IconThemeData(color: kAppBarGrey),
        automaticallyImplyLeading: false,
        centerTitle: true,
        // leadingWidth: 16,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: kWhite,
          ),
          iconSize: 20,
        ),
        title: Text(
          "Profile",
          textAlign: TextAlign.left,
          style: OnestopFonts.w500.size(23).setColor(kWhite),
        ),
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
                  style: OnestopFonts.w600.size(16).setColor(kWhite)),
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
                semiTitle: widget.profileModel.phoneNumber?.toString(),
              ),
              DataTile(
                title: 'Emergency Contact Number',
                semiTitle: widget.profileModel.emergencyPhoneNumber?.toString(),
              ),
              DataTile(
                title: 'Hostel',
                semiTitle: widget.profileModel.hostel,
              ),
              widget.profileModel.dob == null
                  ? Container()
                  : DataTile(
                      title: 'Date of Birth',
                      semiTitle: DateFormat('dd-MMM-yyyy')
                          .format(DateTime.parse(widget.profileModel.dob!)),
                    ),
              DataTile(
                title: 'Home Address',
                semiTitle: widget.profileModel.homeAddress,
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
      floatingActionButton: LoginStore.isGuest
          ? Container()
          : GestureDetector(
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
