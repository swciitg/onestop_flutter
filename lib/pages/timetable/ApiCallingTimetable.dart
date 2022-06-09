import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../models/timetable.dart';

class ApiCalling {
  Map<int, List<List<String>>> Data1 = {};
  Map<int, List<List<String>>> Data2 = {};
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
  List<Map<int, List<List<String>>>>addWidgets({required Time data}) {
    List<Map<int, List<List<String>>>>ans=[];
    data.courses!.sort((a, b) => a.slot!.compareTo(b.slot!));
    List<List<String>> a1 = [];
    List<List<String>> a2 = [];
    List<List<String>> a3 = [];
    List<List<String>> a4 = [];
    List<List<String>> a5 = [];
    List<List<String>> a11 = [];
    List<List<String>> a21 = [];
    List<List<String>> a31 = [];
    List<List<String>> a41 = [];
    List<List<String>> a51 = [];
    for (int i = 1; i <= 5; i++) {
      for (var v in data.courses!) {
        if (i == 1 && v.slot == 'A')
          a1.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B')
          a1.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D')
          a1.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F')
          a1.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'A1')
          a11.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'B1')
          a11.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'D1')
          a11.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 1 && v.slot == 'F1')
          a11.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 2 && v.slot == 'A')
          a2.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C')
          a2.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D')
          a2.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F')
          a2.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'A1')
          a21.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'C1')
          a21.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'D1')
          a21.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 2 && v.slot == 'F1')
          a21.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 3 && v.slot == 'A')
          a3.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C')
          a3.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E')
          a3.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G')
          a3.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'A1')
          a31.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'C1')
          a31.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'E1')
          a31.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 3 && v.slot == 'G1')
          a31.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 4 && v.slot == 'B')
          a4.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C')
          a4.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E')
          a4.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G')
          a4.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'B1')
          a41.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'C1')
          a41.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'E1')
          a41.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 4 && v.slot == 'G1')
          a41.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);

        if (i == 5 && v.slot == 'B')
          a5.add(['09:00 - 09:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'C')
          a5.add(['10:00 - 10:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F')
          a5.add(['11:00 - 11:55 AM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G')
          a5.add(['12:00 - 12:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'B1')
          a51.add(['02:00 - 02:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'C1')
          a51.add(['03:00 - 03:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'F1')
          a51.add(['04:00 - 04:55 PM', v.course!, v.instructor!]);
        if (i == 5 && v.slot == 'G1')
          a51.add(['05:00 - 05:55 PM', v.course!, v.instructor!]);
      }
    }
    Data1.addAll({1: a1});
    Data1.addAll({2: a2});
    Data1.addAll({3: a3});
    Data1.addAll({4: a4});
    Data1.addAll({5: a5});

    Data2.addAll({1: a11});
    Data2.addAll({2: a21});
    Data2.addAll({3: a31});
    Data2.addAll({4: a41});
    Data2.addAll({5: a51});
    ans.add(Data1);
    ans.add(Data2);
    return ans;
  }
}
