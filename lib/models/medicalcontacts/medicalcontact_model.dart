import 'package:onestop_dev/models/medicalcontacts/dropdown_contact_model.dart';

class MedicalcontactModel {
  late DropdownContactModel name;
  String? miscellaneousContact;
  String? category;
  String? email;
  String? phone;
  String? designation;
  String? degree;

  MedicalcontactModel(
      {required this.name,
      this.miscellaneousContact,
      this.category,
      this.email,
      this.phone,
      this.designation,
      this.degree});

  MedicalcontactModel.fromJson(Map<String, dynamic> json) {
    name = DropdownContactModel.fromJson(json['name'] as Map<String, dynamic>? ?? {});
    miscellaneousContact = json['miscellaneous_contact'] ?? "";
    category = json['category'];
    email = json['email'];
    phone = json['phone'] ?? "";
    designation = json['designation'] ?? "";
    degree = json['degree'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['miscellaneous_contact'] = miscellaneousContact;
    data['category'] = category;
    data['email'] = email;
    data['phone'] = phone;
    data['designation'] = designation;
    data['degree'] = degree;
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
}
