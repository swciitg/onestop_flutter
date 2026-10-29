class Club {
  final String id;
  final String name;
  final String logo;
  final String board;
  final String description;

  const Club({
    required this.id,
    required this.name,
    this.logo = '',
    this.board = '',
    this.description = '',
  });

  factory Club.fromJson(Map json) {
    return Club(
      id: json['club_id']?.toString() ?? '',
      name: json['clubName']?.toString() ?? '',
      logo: json['clubLogo']?.toString() ?? '',
      board: json['boardName']?.toString() ?? '',
      description: json['clubDescription']?.toString() ?? '',
    );
  }
}

/// Response of `/api/v1/clubs/check-secy`. A secretary is treated as an admin.
class SecyStatus {
  final bool isSecy;
  final Club? club;

  const SecyStatus({required this.isSecy, this.club});

  bool get isAdmin => isSecy;

  factory SecyStatus.fromJson(Map<String, dynamic> json) {
    final isSecy = json['isSecy'] == true;
    final clubJson = json['club'];
    return SecyStatus(
      isSecy: isSecy,
      club: isSecy && clubJson is Map ? Club.fromJson(clubJson) : null,
    );
  }
}
