import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:onestop_dev/services/api.dart';

Future<String?> uploadFile()async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path!);
    int? status= await APIService.uploadFileToServer(file);
    if(status==200) return result.files.single.name;
  } else {
    // User canceled the picker
    return null;
  }
  return null;
}