import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_ui/index.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  String selected = 'Issue Report';
  bool enableSubmitButton = true;

  Widget? counterBuilder(
    BuildContext context, {
    required currentLength,
    required isFocused,
    required maxLength,
  }) {
    if (currentLength == 0) {
      return null;
    }
    return Text(
      "$currentLength/$maxLength",
      style: OTextStyle.bodySmall.copyWith(color: OColor.gray500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(OCornerRadius.l)),
      ),
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: OSpacing.xs),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: OColor.gray300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
                      child: Row(
                        children: [
                          Icon(FluentIcons.bug_24_regular, color: OColor.green600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bug / Feature Request',
                              style: OTextStyle.labelLarge.copyWith(color: OColor.gray800),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: OColor.gray100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FluentIcons.dismiss_24_regular,
                                size: 18,
                                color: OColor.gray600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: OColor.gray200),
                    const SizedBox(height: OSpacing.m),

                    // Type selector
                    Text('Type', style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                    const SizedBox(height: OSpacing.xs),
                    Row(
                      children: [
                        _buildTypeChip('Issue Report'),
                        const SizedBox(width: 12),
                        _buildTypeChip('Feature Request'),
                      ],
                    ),
                    const SizedBox(height: OSpacing.m),

                    // Title field
                    Text('Title', style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                    const SizedBox(height: OSpacing.xs),
                    TextFormField(
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                      controller: title,
                      maxLength: 30,
                      maxLines: 1,
                      buildCounter: counterBuilder,
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == "" || value == null) {
                          return "Field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: OSpacing.s),

                    // Body field
                    Text(
                      'Description',
                      style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                    ),
                    const SizedBox(height: OSpacing.xs),
                    TextFormField(
                      style: OTextStyle.bodySmall.copyWith(color: OColor.gray800),
                      controller: body,
                      maxLength: 250,
                      maxLines: 4,
                      buildCounter: counterBuilder,
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == "" || value == null) {
                          return "Field cannot be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: OSpacing.m),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap:
                            !enableSubmitButton
                                ? null
                                : () async {
                                  bool isValid = formKey.currentState!.validate();
                                  if (!isValid) return;

                                  Map<String, String> data = {
                                    'title': title.text,
                                    'body': body.text,
                                    'type': selected,
                                    'user':
                                        "${LoginStore.userData['outlookEmail']} - ${LoginStore.userData["rollNo"] ?? "Unknown"}",
                                  };
                                  setState(() => enableSubmitButton = false);
                                  bool success = await APIRepository().postFeedbackData(data);
                                  String snackBar =
                                      "There was an error while sending your feedback.\nPlease try again later or reach out to any member using the Contacts section.";
                                  if (success) {
                                    snackBar =
                                        "Your feedback was successfully shared to SWC.\nKeep an eye for updates as developers will start working on this shortly.";
                                  }
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  }
                                  rootScaffoldMessengerKey.currentState?.showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 8),
                                      content: Text(
                                        snackBar,
                                        style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                                      ),
                                    ),
                                  );
                                },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: OSpacing.s),
                          decoration: BoxDecoration(
                            color: enableSubmitButton ? OColor.green600 : OColor.gray300,
                            borderRadius: BorderRadius.circular(OCornerRadius.m),
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: OTextStyle.labelMedium.copyWith(color: OColor.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: OSpacing.l),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    final isSelected = selected == label;
    return GestureDetector(
      onTap: () => setState(() => selected = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OCornerRadius.xl),
          color: isSelected ? OColor.green600 : OColor.gray100,
          border: Border.all(color: isSelected ? OColor.green600 : OColor.gray200),
        ),
        child: Text(
          label,
          style: OTextStyle.bodySmall.copyWith(color: isSelected ? OColor.white : OColor.gray600),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      errorStyle: OTextStyle.bodySmall.copyWith(color: OColor.red500, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        borderSide: BorderSide(color: OColor.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        borderSide: BorderSide(color: OColor.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        borderSide: BorderSide(color: OColor.green600),
      ),
      fillColor: OColor.gray100,
      filled: true,
      hintStyle: OTextStyle.bodySmall.copyWith(color: OColor.gray400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
