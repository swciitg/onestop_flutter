import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../models/timetable.dart';

class ApiCalling {
  Future<Time> getTimeTable({required String roll}) async {
    final response = await post(
      Uri.parse('https://hidden-depths-09275.herokuapp.com/get-my-courses'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        "roll_number": roll,
      }),
    );
    if (response.statusCode == 200) {
      return Time.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception(response.statusCode);
    }
  }
}
