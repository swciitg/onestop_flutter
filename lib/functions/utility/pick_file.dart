import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:onestop_dev/services/api.dart';

Future<String?> uploadFile(Function callBack)async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path!);
    callBack();
    String? responseFilename= await APIService.uploadFileToServer(file);
    return responseFilename;
  }
  return null;
}