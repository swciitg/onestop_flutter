import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/pages/home/home.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/upsp/upsp_stepper.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

class DetailsUpsp extends StatefulWidget {
  static const id = '/DetailsUpspPage';
  final Map<String, dynamic> data;

  const DetailsUpsp({super.key, required this.data});

  @override
  State<DetailsUpsp> createState() => _DetailsUpspState();
}

class _DetailsUpspState extends State<DetailsUpsp> {
  bool submitted = false;
  TextEditingController contact = TextEditingController();
  TextEditingController rollNo = TextEditingController();
  List<Hostel> hostels = Hostel.values;
  final _formKey = GlobalKey<FormState>();
  late Hostel selectedHostel;

  bool get _isFormValid => contact.text.trim().length >= 10;

  @override
  void initState() {
    super.initState();
    var userData = LoginStore.userData;
    rollNo.text = userData['rollNo']?.toString() ?? '';
    contact.text = userData['phoneNumber']?.toString() ?? '';
    selectedHostel = userData['hostel']?.toString().getHostelFromDatabaseString() ?? Hostel.none;
    contact.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // ─── Header ───────────────────────────────────────────
              _buildHeader(context),
              // ─── Scrollable form ──────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(OSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: OSpacing.m),
                      Text(
                        'Personal Details',
                        style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                      ),
                      const SizedBox(height: OSpacing.xs),
                      Text(
                        'Please verify your personal details below before submitting.',
                        style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                      ),
                      const SizedBox(height: OSpacing.xl),

                      // ─── Roll Number (read-only) ─────────────────
                      _buildFieldLabel('Roll Number'),
                      const SizedBox(height: OSpacing.xs),
                      _buildTextField(
                        controller: rollNo,
                        hintText: 'Your roll number',
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                      const SizedBox(height: OSpacing.l),

                      // ─── Contact Number ───────────────────────────
                      _buildFieldLabel('Contact Number'),
                      const SizedBox(height: OSpacing.xs),
                      _buildTextField(
                        controller: contact,
                        hintText: '+91 XXXXXXXXXX',
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please fill your contact number';
                          }
                          if (val.length < 10) {
                            return 'Enter a valid contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: OSpacing.l),

                      // ─── Hostel (read-only) ───────────────────────
                      _buildFieldLabel('Your Hostel'),
                      const SizedBox(height: OSpacing.xs),
                      Container(
                        decoration: BoxDecoration(
                          color: OColor.gray100,
                          borderRadius: BorderRadius.circular(OCornerRadius.m),
                          border: Border.all(color: OColor.gray200),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: OSpacing.m,
                          vertical: OSpacing.s + 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedHostel == Hostel.none
                                    ? 'No hostel set'
                                    : selectedHostel.displayString,
                                style: OTextStyle.bodySmall.copyWith(
                                  color:
                                      selectedHostel == Hostel.none
                                          ? OColor.gray600
                                          : OColor.gray800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Extra space for sticky bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              // ─── Sticky bottom bar ────────────────────────────────
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Header
  // ───────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
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
                        'UPSP',
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.s),
            const UPSPStepper(currentStep: 2),
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
    String? Function(String?)? validator,
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
        validator: validator,
        readOnly: readOnly,
        style: OTextStyle.bodySmall.copyWith(color: readOnly ? OColor.gray600 : OColor.gray800),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
          counterText: '',
          errorStyle: OTextStyle.bodyXSmall.copyWith(color: OColor.red500),
        ),
      ),
    );
  }

  // ─── Submit logic ─────────────────────────────────────────────────────

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (submitted) return;

    setState(() => submitted = true);

    var userData = LoginStore.userData;
    String email = userData['outlookEmail']!;
    String name = userData['name']!;

    Map<String, dynamic> data = widget.data;
    data['phone'] = contact.text;
    data['hostel'] = selectedHostel.databaseString;
    data['name'] = name;
    data['roll_number'] = rollNo.text;
    data['email'] = email;

    try {
      var response = await APIRepository().postUPSP(data);
      if (!mounted) return;
      if (response['success']) {
        showSnackBar('Your problem has been successfully sent to respective authorities.');
        Navigator.popUntil(context, ModalRoute.withName(HomePage.id));
      } else {
        showSnackBar('Some error occurred. Try again later');
        setState(() => submitted = false);
      }
    } catch (err) {
      showSnackBar('Please check your internet connection and try again');
      setState(() => submitted = false);
    }
  }

  @override
  void dispose() {
    contact.dispose();
    super.dispose();
  }
}
