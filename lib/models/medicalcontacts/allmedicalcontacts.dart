import 'package:json_annotation/json_annotation.dart';
import 'package:onestop_dev/models/medicalcontacts/medicalcontact_model.dart';

part 'allmedicalcontacts.g.dart';

@JsonSerializable()
class Allmedicalcontacts {
  @JsonKey(defaultValue: [])
  late List<MedicalcontactModel> alldoctors;

  Allmedicalcontacts({ required this.alldoctors});

  void addDocToList(MedicalcontactModel c) => alldoctors.add(c);
  
 factory Allmedicalcontacts.fromJson(Map<String, dynamic> json) =>
      _$AllmedicalcontactsFromJson(json);

  Map<String, dynamic> toJson() => _$AllmedicalcontactsToJson(this);
}
