import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/upsp/checkbox_list.dart';
import 'package:onestop_dev/widgets/upsp/file_tile.dart';
import 'package:onestop_dev/widgets/upsp/upload_button.dart';
import 'package:onestop_dev/widgets/upsp/upsp_stepper.dart';
import 'package:onestop_ui/index.dart';

import 'details_upsp.dart';

const List<String> boards = [
  'Sports Board',
  'Technical Board',
  'Cultural Board',
  'Welfare Board',
  'Student Alumni Interaction Linkage (SAIL) ',
  'Students Web Committee (SWC)',
  'Students Academic Board (SAB)',
  'Others',
];

const List<String> subcommittees = [
  'Maintenance',
  'Services',
  'Finance',
  'Academic',
  'Rights and Responsibilities',
  'RTI (Right to Information)',
  'Medical Related Issues',
];

class Upsp extends StatefulWidget {
  static const String id = "/upsp";

  const Upsp({super.key});

  @override
  State<Upsp> createState() => _UpspState();
}

class _UpspState extends State<Upsp> {
  List<String> files = [];
  TextEditingController problem = TextEditingController();
  RadioButtonListController subcommitteeController = RadioButtonListController();
  RadioButtonListController boardsController = RadioButtonListController();

  bool get _isFormValid => problem.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    problem.addListener(() => setState(() {}));
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
                    // ─── Header (AppBar + Stepper) ────────────────────────
                    _buildHeader(context),
                    // ─── Scrollable form content ──────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(OSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: OSpacing.m),
                            // Section heading
                            Text(
                              'Problem',
                              style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            Text(
                              'Fill this OneStop form to address your Academic, Technical, Cultural or Welfare problems directly to the respective boards.',
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                            ),
                            const SizedBox(height: OSpacing.xl),

                            // ─── Feedback text field ──────────────────────
                            Text(
                              'Feedback',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                            ),
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

                            // ─── Upload images ────────────────────────────
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
                              UploadButton(
                                callBack: (fName) {
                                  if (fName != null) files.add(fName);
                                  setState(() {});
                                },
                                endpoint: Endpoints.uploadFileUPSP,
                              ),
                            const SizedBox(height: OSpacing.xxs),
                            Text(
                              'File can be a photograph, video or a pdf file.',
                              style: OTextStyle.bodySmall.copyWith(color: OColor.gray600),
                            ),
                            const SizedBox(height: OSpacing.l),

                            // ─── Boards list ──────────────────────────────
                            Text(
                              'Respective Board dealing with the grievance raised',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            RadioButtonList(values: boards, controller: boardsController),
                            const SizedBox(height: OSpacing.l),

                            // ─── Subcommittees list ───────────────────────
                            Text(
                              'Respective Subcommittee dealing with the grievance raised',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                            ),
                            const SizedBox(height: OSpacing.xs),
                            RadioButtonList(
                              values: subcommittees,
                              controller: subcommitteeController,
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
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Header: SafeArea + back button + "UPSP" title + stepper + divider
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
                  // Invisible spacer for centering
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.s),
            const UPSPStepper(currentStep: 1),
            const SizedBox(height: OSpacing.s),
            Divider(height: 1, color: OColor.gray200),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Sticky bottom: Cancel + Next buttons with shadow
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
    if (problem.value.text.isEmpty) {
      showSnackBar("Problem description cannot be empty");
    } else {
      Map<String, dynamic> data = {
        'problem': problem.text,
        'files': files,
        'boards': boardsController.selectedItem,
        'subcommittees': subcommitteeController.selectedItem,
      };
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsUpsp(data: data)));
    }
  }

  @override
  void dispose() {
    problem.dispose();
    subcommitteeController.dispose();
    boardsController.dispose();
    super.dispose();
  }
}
