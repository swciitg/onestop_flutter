import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'api_caller.dart';


class Service{
  static Future<String?> uploadFile()async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      int? status= ApiCaller.uploadFileToServer(file) as int?;
      if(status==200) return result.files.single.name;
    } else {
      // User canceled the picker
    }
  }
}