import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import "package:dio/dio.dart";

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

class ApiCaller {
  static Future<int?>uploadFileToServer(File file) async {
    String urlapi = "";
    var fileName = file.path.split('/').last;
    print(fileName);
    var formData = FormData.fromMap({
      'uploaded_file':
          await MultipartFile.fromFile(file.path, filename: fileName),
    });
    try {
      var response = await Dio().post('${urlapi}',
          options: Options(
            contentType: 'multipart/form-data',
          ),
          data: formData, onSendProgress: (int send, int total) {
            print((send / total) * 100);
          });
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response);
      } else {
        print(e.message);
      }
      return 400;
    }

  }
}
