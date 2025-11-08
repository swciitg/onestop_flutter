// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import '../../globals/my_fonts.dart';
import '../../stores/login_store.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ProfilePage extends StatefulWidget {
  final OneStopUser profileModel;

  const ProfilePage({super.key, required this.profileModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late OneStopUser _user; 

  @override
  void initState() {
    super.initState();
    _user = widget.profileModel; 
  }
  
  void handleFieldUpdate(String label, String newValue) async{
  setState(() {
    switch (label) {
      case 'Alternate Email':
        _user = _user.copyWith(altEmail: newValue);
        break;
      case 'Cycle Registration Number':
        _user = _user.copyWith(cycleReg: newValue);
        break;
      case 'Linkedin Profile':
        _user = _user.copyWith(linkedin: newValue);
        break;
    }
  });
   final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userInfo', jsonEncode(_user.toJson()));

  LoginStore.userData = _user.toJson();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        iconTheme:  IconThemeData(color: OColor.green600),
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          textAlign: TextAlign.left,
          style: OTextStyle.headingLarge.copyWith(color: OColor.gray800)
        ),
      actions: [
        IconButton(
      icon: const Icon(Icons.notifications_outlined),
      onPressed: () {
      },
    ),
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
                height: OSpacing.s,
              ),
              Container(
                width: 400,
                padding: const EdgeInsets.all(OSpacing.m),
                decoration: BoxDecoration(
                  color: OColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
                  border: Border.all(color: OColor.green600)
                ),
                child: Column( 
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                       Row(  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Image.asset('assets/images/iitg_logo.png', height: 40,),
                           SizedBox(width: 16,),
                           Column( crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Indian Institute of', style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),),
                              Text('Technology, Guwahati', style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),)
                            ],
                           )
                        ],
                       ),
                       const SizedBox(height: OSpacing.s),
                          Divider(thickness: 1, color: OColor.gray200,),
                        const SizedBox(height: OSpacing.s),

                        const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/images/profile_placeholder.jpg'),
                        ),
                        const SizedBox(height: OSpacing.s),
                           Text(_user.name,
                          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)
                         ),
                        const SizedBox(height: OSpacing.xxs),
                         Text(_user.rollNo,
                          style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800)
                         ),
                        const SizedBox(height: OSpacing.xxs),
                         Text('CSE Department',
                          style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800)
                         ),
                        const SizedBox(height: OSpacing.m),
                          BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: _user.rollNo, 
                         width: 200,
                        height: 60,
                        drawText: false,
                        color: OColor.black, 
                       ),

                       const SizedBox(height: 10),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 28,),
              Text('Additional Information',
                  style: MyFonts.w500.copyWith(color: OColor.gray800)),
              const SizedBox(
                height: OSpacing.m,
              ),
              
                  Container(
               width: 400,
                padding: const EdgeInsets.all(OSpacing.m),
               decoration: BoxDecoration(
                 color: OColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
                  border: Border.all(color: OColor.green600)
             ),
                child: Column(
                 children:  [
                 InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Outlook ID',
                  value: _user.outlookEmail,
            ),
                  InfoTile(
                   icon: Icons.email_outlined,
                  label: 'Alternate Email',
                  value: _user.altEmail ?? '',
                 editable: true,
                 onUpdated: handleFieldUpdate,
            ),
                   InfoTile(
                    icon: Icons.phone_outlined,
                  label: 'Contact Number',
                  value: _user.phoneNumber?.toString() ?? '',
             ),
                InfoTile(
                 icon: Icons.phone,
                label: 'Emergency Contact Number',
                value: _user.emergencyPhoneNumber?.toString() ?? '',
          ),
             InfoTile(
            icon: Icons.home_outlined,
            label: 'Hostel',
            value: _user.hostel  ?.getHostelFromDatabaseString()
                    ?.displayString ?? '',
          ),
          InfoTile(
            icon: Icons.restaurant_outlined,
            label: 'Subscribed Mess',
            value: _user.subscribedMess
                      ?.getMessFromDatabaseString()
                      ?.displayString?? '',
          ),
          InfoTile(
            icon: Icons.calendar_today_outlined,
            label: 'Date of Birth',
            value: DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(_user.dob!)),
                    
          ),
          InfoTile(
            icon: Icons.home_outlined,
            label: 'Home Address',
            value: _user.homeAddress ??'',
          ),
          InfoTile(
            icon: Icons.pedal_bike_outlined,
            label: 'Cycle Registration Number',
            value: _user.cycleReg ?? '',
            editable: true,
            onUpdated: handleFieldUpdate,
          ),
          InfoTile(
            icon: Icons.link_outlined,
            label: 'Linkedin Profile',
            value: _user.linkedin ?? '',
            editable: true,
            onUpdated: handleFieldUpdate,
            showdivider: false,
          ),
        ],
      )
                  ),
              const SizedBox(
                height: OSpacing.l,
              ),
              SizedBox(
               width: double.infinity,
                child: OutlinedButton.icon(
                 onPressed: () {
                     LoginStore().logOut(() => Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false));
               },
              icon:  Icon(Icons.logout_outlined, color: OColor.red600),
               label:  Text(
                  "Log Out",
                style: OTextStyle.labelMedium.copyWith(color: OColor.red600)
           ),
                 style: OutlinedButton.styleFrom(
                 side:  BorderSide(color: OColor.gray200, width: 1),
                 shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(16),
            ),
                 padding: const EdgeInsets.symmetric(vertical: 12),
                 backgroundColor: OColor.white,
          ),
         ),
        ),
                    SizedBox(height: 50,),

            ],
          ),
        )),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool editable;
  final bool showdivider;
  final Function(String label, String newValue)? onUpdated;

const InfoTile({
  super.key,
  required this.icon,
  required this.label,
  required this.value,
  this.editable = false,
  this.showdivider = true,
  this.onUpdated,
});



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: OColor.green600, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray600)
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  Text(
                    value,
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800)
                  ),
                ],
              ),
            ),
           if (editable)
  IconButton(
    onPressed: () {
      showEditSheet(
        context,
        icon,
        label,
        value,
        (newValue) {
          onUpdated?.call(label, newValue);
        },
      );
    },
    icon: Icon(Icons.edit_outlined, color: OColor.green600, size: 16),
  ),

          ],
        ),
         const SizedBox(height: 10),
        if (showdivider) ...[
         
          Divider(color: OColor.gray200, thickness: 1),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

void showEditSheet(
  BuildContext context,
  IconData icon,
  String label,
  String currentValue,
  Function(String newValue) onSave,
) {
  final TextEditingController controller =
      TextEditingController(text: currentValue);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.4,
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Icon(icon, size: 24, color: OColor.gray800,),
                  const SizedBox(width: OSpacing.xs),
                 Expanded(child:  Text(
                    "Edit $label",
                    style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),),
                 
                  IconButton(
                    icon:  Icon(Icons.close, color: OColor.gray600,),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Enter $label",
                style:  OTextStyle.labelMedium.copyWith(color: OColor.gray800)
              ),
              const SizedBox(height: OSpacing.xs),
              TextField(
                controller: controller,
                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                decoration: InputDecoration(
                  hintText: "Enter $label...",hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(OCornerRadius.m), borderSide: BorderSide(
                        color: OColor.gray200,
                        width: 1.0
                      )),
                    
                
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onSave(controller.text.trim());
                  },
                  icon: Icon(Icons.check, color: OColor.white),
                  label: Text(
                    "Save Changes",
                    style: OTextStyle.labelMedium.copyWith(color: OColor.white)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OColor.green600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: OSpacing.xs),
            ],
          ),
        ),
      );
    },
  );
}

