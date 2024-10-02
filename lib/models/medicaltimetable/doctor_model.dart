import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';

class DoctorModel /*implements Comparable<DoctorModel> */ {
  late DropdownContactModel doctor;
  String? degree;
  String? designation;
  String? category;
  String? date;
  String? startTime1;
  String? endTime1;
  String? startTime2;
  String? endTime2;

  DoctorModel({
    required this.doctor,this.degree,this.designation,this.category,this.date,this.startTime1,this.endTime1,this.startTime2,this.endTime2
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    doctor = DropdownContactModel.fromJson(json['doctor'] as Map<String, dynamic>);
    degree = json['degree'] ?? "";
    designation = json['designation'] ?? "";
    category = json['category'];
    date = json['date'].toString().substring(0,10);
    startTime1 = json['startTime1'] ?? "";
    endTime1 = json['endTime1'] ?? "";
    startTime2 = json['startTime2'] ?? "";
    endTime2 = json['endTime2'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor'] = doctor;
    data['degree'] = degree;
    data['designation'] = designation;
    data['category'] = category;
    data['date'] = date;
    data['startTime1'] = startTime1;
    data['endTime1'] = endTime1;
    data['startTime2'] = startTime2;
    data['endTime2'] = endTime2;
    return data;
  }

  String formatTime(String time) {
    var times = time.split(' - ');
    List<String> ft = [];
    for (var t in times) {
      if (t[1] == ':') {
        t = '0$t';
      }
      ft.add(t);
    }
    return ft.join(' - ');
  }

  DoctorModel.clone(DoctorModel c)
      : this(
          doctor: c.doctor,
          degree: c.degree,
          designation: c.designation,
          category: c.category,
          date: c.date,
          startTime1: c.startTime1,
          endTime1: c.endTime1,
          startTime2: c.startTime2,
          endTime2: c.endTime2 
        );
}
