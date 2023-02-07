import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:onestop_dev/functions/utility/show_snackbar.dart';
import 'package:onestop_dev/services/api.dart';

Future<String?> uploadFile(Function uploadCallback) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
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
