import 'dart:io';

import "package:dio/dio.dart";

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
