import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/repository/user_repository.dart';
import 'package:onestop_dev/services/app_icon_service.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/pages/theme/theme_transition_screen.dart';
import 'package:onestop_dev/widgets/profile/feedback.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../main.dart';

String _getUserProfileUrlByRoll(String rollNo) {
  return "https://online.iitg.ac.in/sprofile/GALLERY/20${rollNo.substring(0, 2)}/PHOTO/${rollNo}_P.jpg";
}

/// Profile tab shown inside the home page bottom navigation.
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late OneStopUser _user;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _user = OneStopUser.fromJson(LoginStore.userData);
  }

  // ── generic field update handler ──────────────────────────────────────
  Future<void> _handleFieldUpdate(String label, String newValue) async {
    setState(() {
      switch (label) {
        case 'Alternate Email':
          _user = _user.copyWith(altEmail: newValue);
          break;
        case 'Contact Number':
          _user = _user.copyWith(phoneNumber: int.tryParse(newValue));
          break;
        case 'Emergency Contact Number':
          _user = _user.copyWith(emergencyPhoneNumber: int.tryParse(newValue));
          break;
        case 'Gender':
          _user = _user.copyWith(gender: newValue);
          break;
        case 'Hostel':
          // newValue is the displayString – convert to databaseString
          final hostel = newValue.getHostelFromDisplayString();
          _user = _user.copyWith(hostel: hostel?.databaseString);
          break;
        case 'Subscribed Mess':
          final mess = newValue.getMessFromDisplayString();
          _user = _user.copyWith(subscribedMess: mess?.databaseString);
          break;
        case 'Room Number':
          _user = _user.copyWith(roomNo: newValue);
          break;
        case 'Date of Birth':
          _user = _user.copyWith(dob: newValue);
          break;
        case 'Home Address':
          _user = _user.copyWith(homeAddress: newValue);
          break;
        case 'Cycle Registration Number':
          _user = _user.copyWith(cycleReg: newValue);
          break;
        case 'LinkedIn Profile':
          _user = _user.copyWith(linkedin: newValue);
          break;
      }
    });

    // persist locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(_user.toJson()));
    LoginStore.userData = _user.toJson();

    // call profile update API with full user data
    try {
      setState(() => _isSaving = true);
      await UserRepository().updateUserProfile(_user.toJson(), null);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: OColor.red500,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (LoginStore.isGuest) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            const Spacer(),
            _buildThemeToggle(),
            const SizedBox(height: OSpacing.s),
            _buildLogoutButton(),
            const SizedBox(height: OSpacing.l),
            _swcLogo(),
            const Spacer(),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(OCornerRadius.l),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 160, // room for bottom nav
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── ID card ────────────────────────────────────────────
                  _buildIdCard(),
                  const SizedBox(height: 28),

                  // ── additional info ────────────────────────────────────
                  OText(
                    text: 'Additional Information',
                    style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                  ),
                  const SizedBox(height: OSpacing.m),
                  _buildInfoSection(),
                  const SizedBox(height: OSpacing.l),

                  // ── Bug/Feature Request + About Us + SWC logo ─────────
                  _buildExtrasSection(),
                  const SizedBox(height: OSpacing.s),

                  // ── theme toggle ───────────────────────────────────────
                  _buildThemeToggle(),
                  const SizedBox(height: OSpacing.s),

                  // ── logout button ──────────────────────────────────────
                  _buildLogoutButton(),
                  const SizedBox(height: OSpacing.l),
                  // SWC logo
                  _swcLogo(),
                  const SizedBox(height: 50),
                ],
              ),
            ),

            // saving indicator
            if (_isSaving)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: Center(child: CircularProgressIndicator(color: OColor.green600)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Row _swcLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          height: 40,
          colorFilter: ColorFilter.mode(OColor.black, BlendMode.srcIn),
        ),
      ],
    );
  }

  // ── ID card widget ──────────────────────────────────────────────────
  Widget _buildIdCard() {
    final profileUrl = _getUserProfileUrlByRoll(_user.rollNo);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OSpacing.m),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
        border: Border.all(color: OColor.green600),
      ),
      child: Column(
        children: [
          // IITG header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iitg_logo.png', height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Indian Institute of',
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                  ),
                  Text(
                    'Technology, Guwahati',
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: OSpacing.s),
          Divider(thickness: 1, color: OColor.gray200),
          const SizedBox(height: OSpacing.s),

          // Avatar – loaded from IITG profile URL
          CircleAvatar(
            radius: 45,
            backgroundColor: OColor.gray200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profileUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorWidget:
                    (_, _, _) => Container(
                      width: 90,
                      height: 90,
                      color: OColor.gray200,
                      child: Icon(FluentIcons.person_24_regular, color: OColor.gray500, size: 40),
                    ),
              ),
            ),
          ),
          const SizedBox(height: OSpacing.s),

          // Name
          OText(
            text: _user.name,
            style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: OSpacing.xxs),

          // Roll number
          OText(
            text: _user.rollNo,
            style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
          ),
          const SizedBox(height: OSpacing.xxs),

          // Department
          OText(
            text: _getDepartment(),
            style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
          ),
          const SizedBox(height: OSpacing.m),

          // Barcode of roll number
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
      ),
    );
  }

  String _getDepartment() {
    return 'IIT Guwahati';
  }

  // ── additional info section ─────────────────────────────────────────
  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(OSpacing.m),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: const BorderRadius.all(Radius.circular(OCornerRadius.l)),
        border: Border.all(color: OColor.gray200),
      ),
      child: Column(
        children: [
          // ── non-editable ───────────────────────────────────────
          _InfoTile(
            icon: FluentIcons.mail_24_regular,
            label: 'Outlook ID',
            value: _user.outlookEmail,
          ),
          // ── editable text fields ───────────────────────────────
          _InfoTile(
            icon: FluentIcons.mail_24_regular,
            label: 'Alternate Email',
            value: _user.altEmail ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.call_24_regular,
            label: 'Contact Number',
            value: _user.phoneNumber?.toString() ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
            keyboardType: TextInputType.phone,
          ),
          _InfoTile(
            icon: FluentIcons.call_24_regular,
            label: 'Emergency Contact Number',
            value: _user.emergencyPhoneNumber?.toString() ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
            keyboardType: TextInputType.phone,
          ),
          // ── dropdown: Gender ───────────────────────────────────
          _InfoTile(
            icon: FluentIcons.person_24_regular,
            label: 'Gender',
            value: _user.gender ?? '',
            editable: true,
            isDropdown: true,
            dropdownOptions: const ['Male', 'Female', 'Other'],
            onUpdated: _handleFieldUpdate,
          ),
          // ── dropdown: Hostel ───────────────────────────────────
          _InfoTile(
            icon: FluentIcons.building_24_regular,
            label: 'Hostel',
            value: _user.hostel?.getHostelFromDatabaseString()?.displayString ?? '',
            editable: true,
            isDropdown: true,
            dropdownOptions:
                Hostel.values.where((h) => h != Hostel.none).map((h) => h.displayString).toList(),
            onUpdated: _handleFieldUpdate,
          ),
          // ── dropdown: Subscribed Mess ──────────────────────────
          _InfoTile(
            icon: FluentIcons.food_24_regular,
            label: 'Subscribed Mess',
            value: _user.subscribedMess?.getMessFromDatabaseString()?.displayString ?? '',
            editable: true,
            isDropdown: true,
            dropdownOptions:
                Mess.values.where((m) => m != Mess.none).map((m) => m.displayString).toList(),
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.building_24_regular,
            label: 'Room Number',
            value: _user.roomNo ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.calendar_ltr_24_regular,
            label: 'Date of Birth',
            value:
                _user.dob != null
                    ? DateFormat('dd-MM-yyyy').format(DateTime.parse(_user.dob!))
                    : '',
            editable: true,
            isDatePicker: true,
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.home_24_regular,
            label: 'Home Address',
            value: _user.homeAddress ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.vehicle_bicycle_24_regular,
            label: 'Cycle Registration Number',
            value: _user.cycleReg ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
          ),
          _InfoTile(
            icon: FluentIcons.link_24_regular,
            label: 'LinkedIn Profile',
            value: _user.linkedin ?? '',
            editable: true,
            onUpdated: _handleFieldUpdate,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  // ── extras: Bug/Feature Request, About Us, SWC logo ─────────────────
  Widget _buildExtrasSection() {
    return Column(
      children: [
        // About Us
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              try {
                await launchUrlString(
                  'https://swc.iitg.ac.in',
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                log('ERROR launching URL: https://swc.iitg.ac.in');
              }
            },
            icon: Icon(FluentIcons.info_24_regular, color: OColor.gray800),
            label: Text('About Us', style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: OColor.gray200, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: OColor.white,
            ),
          ),
        ),
        const SizedBox(height: OSpacing.s),
        // Bug / Feature Request
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext ctx) => const FeedBack(),
              );
            },
            icon: Icon(FluentIcons.bug_24_regular, color: OColor.gray800),
            label: Text(
              'Bug/Feature Request',
              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: OColor.gray200, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: OColor.white,
            ),
          ),
        ),
      ],
    );
  }

  // ── theme toggle ─────────────────────────────────────────────────────
  Widget _buildThemeToggle() {
    return Consumer<ThemeStore>(
      builder: (context, themeStore, child) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, _, _) => ThemeTransitionScreen(toLight: themeStore.isDarkMode),
                  transitionsBuilder: (_, animation, _, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
              // Rebuild to set the new theme in stuborn widgets
              setState(() {});
              if (Platform.isAndroid) {
                Future.delayed(const Duration(milliseconds: 300));
                _showIconChangeDialog();
              }
            },
            icon: Icon(
              themeStore.isLightMode
                  ? FluentIcons.weather_moon_24_regular
                  : FluentIcons.weather_sunny_24_regular,
              color: OColor.gray800,
            ),
            label: Text(
              themeStore.isLightMode ? 'Switch to Dark Mode' : 'Switch to Light Mode',
              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: OColor.gray200, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: OColor.white,
            ),
          ),
        );
      },
    );
  }

  void _showIconChangeDialog() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final darkMode = ThemeStore.instance.isDarkMode;

    // Theme has already been toggled by the time this dialog shows,
    // so toLight is now stale — swap the references.
    final currentIconAsset =
        darkMode ? 'assets/images/app_logo_light.png' : 'assets/images/app_logo_dark.png';
    final newIconAsset =
        darkMode ? 'assets/images/app_logo_dark.png' : 'assets/images/app_logo_light.png';
    final newIconName = darkMode ? 'dark' : 'light';

    showDialog(
      context: ctx,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: OColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Change App Icon?',
            style: OTextStyle.headingSmall.copyWith(color: OColor.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Current icon
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(currentIconAsset, width: 64, height: 64),
                      ),
                      const SizedBox(height: 8),
                      Text('Current', style: OTextStyle.bodySmall.copyWith(color: OColor.gray500)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.arrow_forward_rounded, color: OColor.gray400, size: 24),
                  ),
                  // New icon
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(newIconAsset, width: 64, height: 64),
                      ),
                      const SizedBox(height: 8),
                      Text('New', style: OTextStyle.bodySmall.copyWith(color: OColor.green600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Changing the icon may close the app. You will need to reopen it.',
                style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text('Not Now', style: OTextStyle.labelMedium.copyWith(color: OColor.gray500)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                await AppIconService.setIcon(newIconName);
              },
              child: Text(
                'Change Icon',
                style: OTextStyle.labelMedium.copyWith(color: OColor.green600),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── logout ──────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          LoginStore().logOut(
            () =>
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
          );
        },
        icon: Icon(Icons.logout_outlined, color: OColor.red600),
        label: Text('Log Out', style: OTextStyle.labelMedium.copyWith(color: OColor.red600)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: OColor.gray200, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(OCornerRadius.l)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: OColor.white,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════
// Private info tile used only by ProfileTab
// ═════════════════════════════════════════════════════════════════════════
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool editable;
  final bool showDivider;
  final bool isDropdown;
  final bool isDatePicker;
  final List<String>? dropdownOptions;
  final TextInputType? keyboardType;
  final Function(String label, String newValue)? onUpdated;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.editable = false,
    this.showDivider = true,
    this.isDropdown = false,
    this.isDatePicker = false,
    this.dropdownOptions,
    this.keyboardType,
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
                  OText(
                    text: label,
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray600),
                  ),
                  const SizedBox(height: OSpacing.xxs),
                  OText(
                    text: value,
                    style: OTextStyle.headingXSmall.copyWith(color: OColor.gray800),
                  ),
                ],
              ),
            ),
            if (editable)
              IconButton(
                onPressed: () {
                  if (isDatePicker) {
                    _showDatePickerDialog(context);
                  } else if (isDropdown && dropdownOptions != null) {
                    _showDropdownSheet(context);
                  } else {
                    _showEditSheet(context);
                  }
                },
                icon: Icon(FluentIcons.edit_24_regular, color: OColor.green600, size: 16),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (showDivider) ...[
          Divider(color: OColor.gray200, thickness: 1),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // ── dropdown bottom sheet (Gender / Mess / Hostel) ──────────────────
  void _showDropdownSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.5),
          decoration: BoxDecoration(
            color: OColor.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Row(
                children: [
                  Icon(icon, size: 24, color: OColor.gray800),
                  const SizedBox(width: OSpacing.xs),
                  Expanded(
                    child: OText(
                      text: 'Select $label',
                      style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: OColor.gray600),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: dropdownOptions!.length,
                  separatorBuilder: (_, _) => Divider(color: OColor.gray200, thickness: 1),
                  itemBuilder: (_, i) {
                    final option = dropdownOptions![i];
                    final isSelected = option == value;
                    return ListTile(
                      dense: true,
                      title: Text(
                        option,
                        style: OTextStyle.bodySmall.copyWith(
                          color: isSelected ? OColor.green600 : OColor.gray800,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing:
                          isSelected ? Icon(Icons.check, color: OColor.green600, size: 20) : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        onUpdated?.call(label, option);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── date picker dialog ─────────────────────────────────────────────
  void _showDatePickerDialog(BuildContext context) async {
    // Parse the current value to get initial date
    DateTime initialDate = DateTime.now();
    if (value.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(value);
      } catch (_) {
        try {
          initialDate = DateTime.parse(value);
        } catch (_) {}
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: OColor.green600, onSurface: OColor.gray800),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final isoDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toIso8601String();
      onUpdated?.call(label, isoDate);
    }
  }

  // ── text-field bottom sheet ─────────────────────────────────────────
  void _showEditSheet(BuildContext context) {
    final controller = TextEditingController(text: value);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  children: [
                    Icon(icon, size: 24, color: OColor.gray800),
                    const SizedBox(width: OSpacing.xs),
                    Expanded(
                      child: OText(
                        text: 'Edit $label',
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: OColor.gray600),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // text field label
                OText(
                  text: 'Enter $label',
                  style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                ),
                const SizedBox(height: OSpacing.xs),

                // input
                TextField(
                  controller: controller,
                  keyboardType: keyboardType ?? TextInputType.text,
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                  decoration: InputDecoration(
                    hintText: 'Enter $label...',
                    hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                      borderSide: BorderSide(color: OColor.gray200, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                      borderSide: BorderSide(color: OColor.gray200, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(OCornerRadius.m),
                      borderSide: BorderSide(color: OColor.green600, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onUpdated?.call(label, controller.text.trim());
                    },
                    icon: Icon(Icons.check, color: OColor.white),
                    label: OText(
                      text: 'Save Changes',
                      style: OTextStyle.labelMedium.copyWith(color: OColor.white),
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
}
