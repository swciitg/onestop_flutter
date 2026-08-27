class StudentModel {
  final String? id;
  final String? name;
  final String email;
  final String? branch;
  final String? year;
  final String rollNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentModel({
    this.id,
    this.name,
    required this.email,
    this.branch,
    this.year,
    required this.rollNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        email: (json['email'] as String?) ?? '',
        branch: json['branch'] as String?,
        year: json['year']?.toString(),
        rollNumber: (json['rollNumber'] as String?) ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        if (name != null) 'name': name,
        'email': email,
        if (branch != null) 'branch': branch,
        if (year != null) 'year': year,
        'rollNumber': rollNumber,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
