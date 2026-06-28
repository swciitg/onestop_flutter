import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/hab/hostel_service_details.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/upsp_stepper.dart';
import 'package:onestop_ui/index.dart';

const List<String> complaintType = ['Services', 'Infra', 'General'];
const List<String> complaintTypeLabels = ['Services', 'Infrastructure', 'General'];
const List<String> complaintTypeDescriptions = [
  'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
  'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
  'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
];

class HostelService extends StatefulWidget {
  static const String id = "/hostelService";

  const HostelService({super.key});

  @override
  State<HostelService> createState() => _HostelServiceState();
}

class _HostelServiceState extends State<HostelService> {
  RadioButtonListController complaintTypeController = RadioButtonListController();

  bool get _isFormValid => complaintTypeController.selectedItem != null;

  @override
  void initState() {
    super.initState();
    complaintTypeController.addListener(() => setState(() {}));
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
                            Text(
                              'Which one of the following best describes your problem?',
                              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            Text(
                              'Your personal details like mail ID and phone number will be visible to others once you post the ad.',
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                            ),
                            const SizedBox(height: OSpacing.xl),
                            RadioButtonList(
                              values: complaintType,
                              labels: complaintTypeLabels,
                              descriptions: complaintTypeDescriptions,
                              controller: complaintTypeController,
                            ),
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
  // Header: SafeArea + back button + title + stepper + divider
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
                        'Hostel Complaints',
                        style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.s),
            const UPSPStepper(currentStep: 1, step1Label: 'CATEGORY', step2Label: 'PROBLEM'),
            const SizedBox(height: OSpacing.s),
            Divider(height: 1, color: OColor.gray200),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Sticky bottom bar: Cancel + Next
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
          // Next
          Expanded(
            child: GestureDetector(
              onTap: _isFormValid ? _onNext : null,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _isFormValid ? OColor.green600 : OColor.gray300,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                  boxShadow:
                      _isFormValid
                          ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 20)]
                          : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next', style: OTextStyle.labelMedium.copyWith(color: OColor.white)),
                    const SizedBox(width: OSpacing.xxs),
                    Icon(FluentIcons.arrow_right_24_regular, size: 24, color: OColor.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => HostelServiceDetails(complaintType: complaintTypeController.selectedItem!),
      ),
    );
  }

  @override
  void dispose() {
    complaintTypeController.dispose();
    super.dispose();
  }
}
