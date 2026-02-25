// ignore_for_file: constant_identifier_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/pages/complaints/complaints_page.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_dev/widgets/upsp/upsp_stepper.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

const List<String> Infra = [
  'Electrician',
  'Carpenter',
  'Sanitation',
  'Plumbing',
  'Civil (Room Painting Damage)',
];

const List<String> Services = ['Canteen', 'Mess', 'Stationary', 'Juice Centre'];

class HostelServiceDetails extends StatefulWidget {
  final String complaintType;

  const HostelServiceDetails({super.key, required this.complaintType});

  @override
  State<HostelServiceDetails> createState() => _HostelServiceDetailsState();
}

class _HostelServiceDetailsState extends State<HostelServiceDetails> {
  List<String> files = [];
  TextEditingController problem = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController complaintID = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController roomNo = TextEditingController();
  RadioButtonListController servicesController = RadioButtonListController();
  RadioButtonListController infraController = RadioButtonListController();
  bool submitted = false;
  List<Hostel> hostels = Hostel.values;
  DateTime? selectedDate;
  late Hostel selectedHostel;

  bool get _isFormValid => problem.text.trim().isNotEmpty && contact.text.trim().length >= 10;

  @override
  void initState() {
    super.initState();
    var userData = LoginStore.userData;
    roomNo.text = userData['roomNo']?.toString() ?? '';
    contact.text = userData['phoneNumber']?.toString() ?? '';
    selectedHostel = userData['hostel']?.toString().getHostelFromDatabaseString() ?? Hostel.none;

    problem.addListener(_refresh);
    contact.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: OColor.green600,
              onPrimary: OColor.white,
              surface: OColor.white,
              onSurface: OColor.gray800,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      body:
          LoginStore.isGuest
              ? Center(
                child: Text(
                  'Please sign in to use this feature',
                  style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                ),
              )
              : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(OSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: OSpacing.m),
                            // ─── Section heading ──────────────────────
                            Text(
                              widget.complaintType == 'Infra' ? 'Enter Details' : 'Problem',
                              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            Text(
                              widget.complaintType == 'Infra'
                                  ? 'File your complaint 72 hours after registering on the IPM Portal'
                                  : 'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                            ),
                            const SizedBox(height: OSpacing.xl),

                            // ─── [Infra] Complaint ID ─────────────────
                            if (widget.complaintType == 'Infra') ...[
                              _buildFieldLabel('Complaint ID'),
                              const SizedBox(height: OSpacing.xs),
                              _buildTextField(
                                controller: complaintID,
                                hintText: 'Eg. 4356776',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9!-]')),
                                ],
                              ),
                              const SizedBox(height: OSpacing.xxs),
                              Text(
                                'Complaint ID registered on the IPM Portal',
                                style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                              ),
                              const SizedBox(height: OSpacing.l),
                            ],

                            // ─── [Infra] Complaint Date ───────────────
                            if (widget.complaintType == 'Infra') ...[
                              _buildFieldLabel('Complaint Date'),
                              const SizedBox(height: OSpacing.xs),
                              _buildDateField(),
                              const SizedBox(height: OSpacing.xxs),
                              Text(
                                'Complaint registration date on the portal',
                                style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                              ),
                              const SizedBox(height: OSpacing.l),
                            ],

                            // ─── Your Hostel ──────────────────────────
                            _buildFieldLabel('Your Hostel'),
                            const SizedBox(height: OSpacing.xs),
                            widget.complaintType == 'Infra'
                                ? _buildReadOnlyHostel()
                                : _buildHostelDropdown(context),
                            const SizedBox(height: OSpacing.l),

                            // ─── Room No. ─────────────────────────────
                            _buildFieldLabel('Room No.'),
                            const SizedBox(height: OSpacing.xs),
                            _buildTextField(
                              controller: roomNo,
                              hintText: 'G-148, B1-26, etc.',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9!-]')),
                              ],
                            ),
                            const SizedBox(height: OSpacing.l),

                            // ─── [Services] Service RadioButtonList ───
                            if (widget.complaintType == 'Services') ...[
                              Text(
                                'On which service would you like to give feedback or register complaint?',
                                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                              ),
                              const SizedBox(height: OSpacing.xs),
                              RadioButtonList(values: Services, controller: servicesController),
                              const SizedBox(height: OSpacing.l),
                            ],

                            // ─── [Infra] Infra RadioButtonList ────────
                            if (widget.complaintType == 'Infra') ...[
                              Text(
                                'On which service would you like to give feedback or register complaint?',
                                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                              ),
                              const SizedBox(height: OSpacing.xs),
                              RadioButtonList(values: Infra, controller: infraController),
                              const SizedBox(height: OSpacing.l),
                            ],

                            // ─── Feedback ─────────────────────────────
                            _buildFieldLabel('Feedback'),
                            const SizedBox(height: OSpacing.xs),
                            Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: OColor.white,
                                borderRadius: BorderRadius.circular(OCornerRadius.m),
                                border: Border.all(color: OColor.gray300),
                              ),
                              child: TextFormField(
                                maxLines: 4,
                                controller: problem,
                                style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(OSpacing.m),
                                  hintText:
                                      'Describe your issue here, with all the necessary details.',
                                  hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                                ),
                              ),
                            ),
                            const SizedBox(height: OSpacing.l),

                            // ─── Contact Number ───────────────────────
                            _buildFieldLabel('Contact Number'),
                            const SizedBox(height: OSpacing.xs),
                            _buildTextField(
                              controller: contact,
                              hintText: '+91 7060633995',
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            const SizedBox(height: OSpacing.l),

                            // ─── Upload images ────────────────────────
                            Text(
                              'Upload supporting images (optional)',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            for (int index = 0; index < files.length; index++) ...[
                              FileTile(
                                filename: files[index],
                                onDelete:
                                    () => setState(() {
                                      files.removeAt(index);
                                    }),
                              ),
                              const SizedBox(height: OSpacing.xs),
                            ],
                            if (files.length < 5)
                              UploadButton2(
                                callBack: (fName) {
                                  if (fName != null) files.add(fName);
                                  setState(() {});
                                },
                              ),
                            const SizedBox(height: OSpacing.xxs),
                            Text(
                              'File can be a photograph, video or a pdf file.',
                              style: OTextStyle.bodyXSmall.copyWith(color: OColor.gray500),
                            ),
                            // Extra space for sticky bar
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(context),
                  ],
                ),
              ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Header: back + title + stepper + divider
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final titleSuffix = widget.complaintType == 'Infra' ? 'Infra' : widget.complaintType;
    return Container(
      color: OColor.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(OSpacing.xs),
                      child: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Hostel Complaints - $titleSuffix',
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.s),
            const UPSPStepper(currentStep: 2, step1Label: 'CATEGORY', step2Label: 'PROBLEM'),
            const SizedBox(height: OSpacing.s),
            Divider(height: 1, color: OColor.gray200),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Sticky bottom bar: Cancel + Send
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: OSpacing.m,
        right: OSpacing.m,
        top: OSpacing.m,
        bottom: MediaQuery.of(context).padding.bottom + OSpacing.m,
      ),
      decoration: BoxDecoration(
        color: OColor.white,
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          // Cancel
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  border: Border.all(color: OColor.gray300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.dismiss_24_regular, size: 24, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text('Cancel', style: OTextStyle.labelMedium.copyWith(color: OColor.green600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: OSpacing.xs),
          // Send
          Expanded(
            child: GestureDetector(
              onTap: (_isFormValid && !submitted) ? _onSubmit : null,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color:
                      submitted
                          ? OColor.gray400
                          : _isFormValid
                          ? OColor.green600
                          : OColor.gray300,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  boxShadow:
                      (_isFormValid && !submitted)
                          ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 20)]
                          : null,
                ),
                child:
                    submitted
                        ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: OColor.white),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                            ),
                            const SizedBox(width: OSpacing.xxs),
                            Icon(FluentIcons.checkmark_24_regular, size: 24, color: OColor.white),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Submit logic ─────────────────────────────────────────────────────

  Future<void> _onSubmit() async {
    if (widget.complaintType == 'Infra' && complaintID.text.isEmpty) {
      showSnackBar('Complaint ID cannot be empty');
      return;
    }
    if (widget.complaintType == 'Infra' && selectedDate == null) {
      showSnackBar('Please select a complaint date');
      return;
    }
    if (widget.complaintType == 'Infra' && infraController.selectedItem == null) {
      showSnackBar('Please select an infrastructure service');
      return;
    }
    if (widget.complaintType == 'Services' && servicesController.selectedItem == null) {
      showSnackBar('Please select a service');
      return;
    }
    if (roomNo.text.isEmpty) {
      showSnackBar('Please enter your room number');
      return;
    }
    if (selectedHostel == Hostel.none) {
      showSnackBar('Please select your hostel');
      return;
    }

    String temp = '';
    if (widget.complaintType == 'Infra') {
      temp = infraController.selectedItem!;
    } else if (widget.complaintType == 'Services') {
      temp = servicesController.selectedItem!;
    } else {
      temp = 'General';
    }

    var userData = LoginStore.userData;
    String email = userData['outlookEmail']!;
    String name = userData['name']!;

    Map<String, dynamic> data = {
      'problem': problem.text,
      'files': files,
      'services': temp,
      'phone': contact.text,
      'name': name,
      'email': email,
      'room_number': roomNo.text,
      'hostel': selectedHostel.databaseString,
      'complaintID': widget.complaintType == 'Infra' ? complaintID.text : null,
      'complaintDate': widget.complaintType == 'Infra' ? selectedDate?.toIso8601String() : null,
      'complaintType': widget.complaintType,
    };

    if (!submitted) {
      setState(() => submitted = true);
      try {
        var response = await APIRepository().postHAB(data);
        if (!mounted) return;
        if (response['success']) {
          showSnackBar('Your problem has been successfully sent to respective authorities.');
          Navigator.popUntil(context, ModalRoute.withName(ComplaintsPage.id));
        } else {
          showSnackBar('Some error occurred. Try again later');
          setState(() => submitted = false);
        }
      } catch (err) {
        showSnackBar('Please check your internet connection and try again');
        setState(() => submitted = false);
      }
    }
  }

  // ─── Reusable helpers ─────────────────────────────────────────────────

  Widget _buildFieldLabel(String text) {
    return Text(text, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? OColor.gray100 : OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: readOnly ? OColor.gray200 : OColor.gray300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        style: OTextStyle.bodySmall.copyWith(color: readOnly ? OColor.gray600 : OColor.gray800),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s + 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateController.text.isEmpty ? 'Select Date' : dateController.text,
                style: OTextStyle.bodySmall.copyWith(
                  color: dateController.text.isEmpty ? OColor.green600 : OColor.gray800,
                ),
              ),
            ),
            Icon(FluentIcons.chevron_right_24_regular, color: OColor.green600, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyHostel() {
    return Container(
      decoration: BoxDecoration(
        color: OColor.gray100,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s + 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedHostel == Hostel.none ? 'No hostel set' : selectedHostel.displayString,
              style: OTextStyle.bodySmall.copyWith(
                color: selectedHostel == Hostel.none ? OColor.gray600 : OColor.gray800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostelDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray300),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: OColor.white),
        child: DropdownButtonFormField<Hostel>(
          initialValue: selectedHostel,
          hint: Text('Choose', style: OTextStyle.bodySmall.copyWith(color: OColor.green600)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: OSpacing.m,
              vertical: OSpacing.s,
            ),
            border: InputBorder.none,
          ),
          icon: Icon(FluentIcons.chevron_down_24_regular, color: OColor.green600, size: 20),
          style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
          onChanged: (data) => setState(() => selectedHostel = data!),
          items:
              hostels.map<DropdownMenuItem<Hostel>>((value) {
                return DropdownMenuItem<Hostel>(
                  value: value,
                  child: Text(
                    value.displayString,
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    problem.dispose();
    contact.dispose();
    complaintID.dispose();
    dateController.dispose();
    roomNo.dispose();
    servicesController.dispose();
    infraController.dispose();
    super.dispose();
  }
}
