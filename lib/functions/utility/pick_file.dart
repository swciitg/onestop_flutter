import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/widgets/upsp/dialog.dart';

enum UPSPDocument { image, pdf }

Future<String?> uploadFile(
    BuildContext context, Function uploadCallback) async {
  var fileType = await showDialog(
      context: context,
      builder: (context) => const UPSPDialog(),
      barrierDismissible: false);
  FilePickerResult? result;
  if (fileType == UPSPDocument.image) {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
  } else if (fileType == UPSPDocument.pdf) {
    result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  }
  if (result != null) {
    File file = File(result.files.single.path!);
    uploadCallback();
    String? responseFilename = await APIService.uploadFileToServer(file);
    if (responseFilename == null) {
      showSnackBar("There was an error uploading your file");
    }
    return responseFilename;
  }
  return null;
}


