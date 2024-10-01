// import 'package:json_annotation/json_annotation.dart';
// import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';

// part 'doctor_model.g.dart';

// @JsonSerializable()
// class DoctorModel {
//   late DropdownContactModel doctor;
//   @JsonKey(defaultValue: "")
//   late String? degree;
//   @JsonKey(defaultValue: "")
//   late String? designation;
//   @JsonKey(defaultValue: "")
//   late String? category;
//   @JsonKey(defaultValue: "")
//   late String? date;
//   @JsonKey(defaultValue: "")
//   late String? startTime1;
//   @JsonKey(defaultValue: "")
//   late String? endTime1;
//   @JsonKey(defaultValue: "")
//   late String? startTime2;
//   @JsonKey(defaultValue: "")
//   late String? endTime2;

//   DoctorModel.clone(DoctorModel c)
//       : this(
//           doctor: c.doctor,
//           degree: c.degree,
//           designation: c.designation,
//           category: c.category,
//           date: c.date,
//           startTime1: c.startTime1,
//           endTime1: c.endTime1,
//           startTime2: c.startTime2,
//           endTime2: c.endTime2 
//         );
  


// //Constructor
//   DoctorModel(
//       {required this.doctor, this.degree,this.designation,this.category,this.date,this.startTime1,this.endTime1,this.startTime2,this.endTime2});
//   factory DoctorModel.fromJson(Map<String, dynamic> json) =>
//       _$DoctorModelFromJson(json);

//   Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
// }


// import 'package:intl/intl.dart';

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

  // DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  //     doctor:
  //         DropdownContactModel.fromJson(json['doctor'] as Map<String, dynamic>),
  //     degree: json['degree'] as String? ?? '',
  //     designation: json['designation'] as String? ?? '',
  //     category: json['category'] as String? ?? '',
  //     date: json['date'] as String? ?? '',
  //     startTime1: json['startTime1'] as String? ?? '',
  //     endTime1: json['endTime1'] as String? ?? '',
  //     startTime2: json['startTime2'] as String? ?? '',
  //     endTime2: json['endTime2'] as String? ?? '',
  //   );

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


  // @override
  // String toString() {
  //   return "$timing : $course";
  // }

  // String get startTime {
  //   List<String> l = timing.split(' ');
  //   List<String> startList = [l.first, l.last];
  //   return startList.join(' ');
  // }

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

  // @override
  // int compareTo(DoctorModel other) {
  //   DateFormat df = DateFormat.jm();
  //   DateTime curr = df.parse(startTime);
  //   DateTime oth = df.parse(other.startTime);
  //   return curr.compareTo(oth);
  // }
}
