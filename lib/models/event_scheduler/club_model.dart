class ClubAchievement {
  final String? title;
  final String? year;

  ClubAchievement({
    this.title,
    this.year,
  });

  factory ClubAchievement.fromJson(Map<String, dynamic> json) => ClubAchievement(
        title: json['title'] as String?,
        year: json['year']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (year != null) 'year': year,
      };
}

class ClubTeamMember {
  final String? name;
  final String? position;
  final String? number;
  final String? email;

  ClubTeamMember({
    this.name,
    this.position,
    this.number,
    this.email,
  });

  factory ClubTeamMember.fromJson(Map<String, dynamic> json) => ClubTeamMember(
        name: json['name'] as String?,
        position: json['position'] as String?,
        number: json['number'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (position != null) 'position': position,
        if (number != null) 'number': number,
        if (email != null) 'email': email,
      };
}

class ClubModel {
  final String? id;
  final String clubName;
  final String? clubLogo;
  final String? clubRoomLocation;
  final String? boardName;
  final String? clubDescription;
  final List<ClubAchievement> achievements;
  final String? howToJoin;
  final List<ClubTeamMember> team;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClubModel({
    this.id,
    required this.clubName,
    this.clubLogo,
    this.clubRoomLocation,
    this.boardName,
    this.clubDescription,
    this.achievements = const [],
    this.howToJoin,
    this.team = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
        id: json['_id'] as String? ?? json['club_id'] as String?,
        clubName: (json['clubName'] as String?) ?? '',
        clubLogo: json['clubLogo'] as String?,
        clubRoomLocation: json['clubRoomLocation'] as String?,
        boardName: json['boardName'] as String?,
        clubDescription: json['clubDescription'] as String?,
        achievements: (json['achievements'] as List<dynamic>?)
                ?.map((e) => ClubAchievement.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        howToJoin: json['howToJoin'] as String?,
        team: (json['team'] as List<dynamic>?)
                ?.map((e) => ClubTeamMember.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        'clubName': clubName,
        if (clubLogo != null) 'clubLogo': clubLogo,
        if (clubRoomLocation != null) 'clubRoomLocation': clubRoomLocation,
        if (boardName != null) 'boardName': boardName,
        if (clubDescription != null) 'clubDescription': clubDescription,
        'achievements': achievements.map((e) => e.toJson()).toList(),
        if (howToJoin != null) 'howToJoin': howToJoin,
        'team': team.map((e) => e.toJson()).toList(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
