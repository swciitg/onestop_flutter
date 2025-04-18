import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/repository/api_repository.dart';
import 'package:onestop_dev/widgets/upsp/dialog.dart';

Future<String?> uploadFile(
    BuildContext context, Function uploadCallback, String endpoint) async {
  var fileType = await showDialog(
      context: context,
      builder: (context) => const UPSPDialog(),
      barrierDismissible: true);
  List<String>? extensions = fileType == FileType.custom ? ['pdf'] : null;
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: fileType, allowedExtensions: extensions);

  if (result != null) {
    File file = File(result.files.single.path!);
    uploadCallback();
    String? responseFilename =
        await APIRepository().uploadFileToServer(file, endpoint);
    if (responseFilename == null) {
      showSnackBar("There was an error uploading your file");
    }
    return responseFilename;
  }
  return null;
}

Future<String?> uploadFile2(
    BuildContext context, Function uploadCallback) async {
  var fileType = await showDialog(
      context: context,
      builder: (context) => const UPSPDialog(),
      barrierDismissible: true);
  List<String>? extensions = fileType == FileType.custom ? ['pdf'] : null;
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: fileType, allowedExtensions: extensions);

  if (result != null) {
    File file = File(result.files.single.path!);
    uploadCallback();
    String? responseFilename = await APIRepository().uploadFileToServer2(file);
    if (responseFilename == null) {
      showSnackBar("There was an error uploading your file");
    }
    return responseFilename;
  }
  return null;
}
