import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/pick_file.dart';
import 'package:onestop_ui/index.dart';

// First Class: UploadButton
class UploadButton extends StatefulWidget {
  const UploadButton({super.key, required this.callBack, required this.endpoint});
  final Function callBack;
  final String endpoint;

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          uploading
              ? null
              : () async {
                String? fileName = await uploadFile(
                  context,
                  () => setState(() {
                    uploading = true;
                  }),
                  widget.endpoint,
                );
                widget.callBack(fileName);
                setState(() {
                  uploading = false;
                });
              },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OCornerRadius.l),
          border: Border.all(color: OColor.gray300),
        ),
        child:
            uploading
                ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: OColor.green600),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.add_16_regular, size: 16, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text(
                      'Add Photo',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                  ],
                ),
      ),
    );
  }
}

// Second Class: UploadButton2
class UploadButton2 extends StatefulWidget {
  const UploadButton2({super.key, required this.callBack});
  final Function callBack;

  @override
  State<UploadButton2> createState() => _UploadButton2State();
}

class _UploadButton2State extends State<UploadButton2> {
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          uploading
              ? null
              : () async {
                String? fileName = await uploadFile2(
                  context,
                  () => setState(() {
                    uploading = true;
                  }),
                );
                widget.callBack(fileName);
                setState(() {
                  uploading = false;
                });
              },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(OCornerRadius.l),
          border: Border.all(color: OColor.gray300),
        ),
        child:
            uploading
                ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: OColor.green600),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.arrow_upload_16_regular, size: 16, color: OColor.green600),
                    const SizedBox(width: OSpacing.xxs),
                    Text(
                      'Upload File',
                      style: OTextStyle.labelSmall.copyWith(color: OColor.green600),
                    ),
                  ],
                ),
      ),
    );
  }
}
