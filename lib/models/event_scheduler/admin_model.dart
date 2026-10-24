class Admin {
  List<Club> clubs;

  Admin({
    required this.clubs,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    json.remove("_id");
    json.remove('__v');
    List<Club> clubs = [];
    for (var e in json.entries) {
      final club = Club(name: e.key, members: ClubMembers.fromJson(e.value));
      clubs.add(club);
    }
    return Admin(clubs: clubs);
  }

  List<Club> getUserClubs(String email) {
    final userClubs = clubs.where((e) {
      final admin = e.members.admins.contains(email);
      return admin;
    }).toList();
    return userClubs;
  }
}

class Club {
  String name;
  ClubMembers members;

  /// Backend club id, when known (used to query the club's events).
  String? id;

  Club({
    required this.name,
    required this.members,
    this.id,
  });
}

/// Response of `/api/v1/clubs/check-secy`. A secretary is treated as an admin.
class SecyStatus {
  final bool isSecy;
  final Club? club;

  const SecyStatus({required this.isSecy, this.club});

  bool get isAdmin => isSecy;

  factory SecyStatus.fromJson(Map<String, dynamic> json, {String email = ''}) {
    final isSecy = json['isSecy'] == true;
    final clubJson = json['club'];
    Club? club;
    if (isSecy && clubJson is Map) {
      final name = clubJson['clubName']?.toString() ?? '';
      club = Club(
        id: clubJson['club_id']?.toString(),
        name: name,
        members: ClubMembers(
          admins: [if (email.isNotEmpty) email],
          clubsOrgs: [],
        ),
      );
    }
    return SecyStatus(isSecy: isSecy, club: club);
  }
}

class ClubMembers {
  List<String> admins;
  List<String> clubsOrgs;

  ClubMembers({
    required this.admins,
    required this.clubsOrgs,
  });

  factory ClubMembers.fromJson(Map<String, dynamic> json) {
    return ClubMembers(
      admins: (json['admins'] as List).map((e) => e.toString()).toList(),
      clubsOrgs: (json['clubs_orgs'] as List).map((e) => e.toString()).toList(),
    );
  }
}
