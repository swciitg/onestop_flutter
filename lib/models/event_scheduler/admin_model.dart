class Admin {
  List<Club> clubs;

  Admin({
    required this.clubs,
  });

  factory Admin.fromJson(Map<String,dynamic> json){
    print(json);
    json.remove("_id");
    json.remove('__v');
    List<Club> clubs = [];
    for(var e in json.entries){
      final club = Club(name: e.key, members: ClubMembers.fromJson(e.value));
      clubs.add(club);
    }
    return Admin(clubs: clubs);
  }

  List<Club> getUserClubs(String email){
    final userClubs = clubs.where((e){
      final admin = e.members.admins.contains(email);
      return admin;
    }).toList();
    return userClubs;
  }
}

class Club {
  String name;
  ClubMembers members;

  Club({
    required this.name,
    required this.members,
  });
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
