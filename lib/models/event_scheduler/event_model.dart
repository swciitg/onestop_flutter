import 'dart:convert';

class EventGuest {
  final String? name;
  final List<String> socials;
  final String? position;
  final String? photo;

  EventGuest({
    this.name,
    this.socials = const [],
    this.position,
    this.photo,
  });

  factory EventGuest.fromJson(Map<String, dynamic> json) => EventGuest(
        name: json['name'] as String?,
        socials: (json['socials'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        position: json['position'] as String?,
        photo: json['photo'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        'socials': socials,
        if (position != null) 'position': position,
        if (photo != null) 'photo': photo,
      };
}

class EventPOC {
  final String? name;
  final String? position;
  final String? number;
  final String? email;

  EventPOC({
    this.name,
    this.position,
    this.number,
    this.email,
  });

  factory EventPOC.fromJson(Map<String, dynamic> json) => EventPOC(
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

class EventStats {
  final int interested;
  final int going;

  EventStats({
    this.interested = 0,
    this.going = 0,
  });

  factory EventStats.fromJson(Map<String, dynamic> json) => EventStats(
        interested: (json['interested'] as num?)?.toInt() ?? 0,
        going: (json['going'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'interested': interested,
        'going': going,
      };
}

class EventUserStatus {
  final bool isInterested;
  final bool isRegistered;

  EventUserStatus({
    this.isInterested = false,
    this.isRegistered = false,
  });

  factory EventUserStatus.fromJson(Map<String, dynamic> json) => EventUserStatus(
        isInterested: (json['isInterested'] as bool?) ?? false,
        isRegistered: (json['isRegistered'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'isInterested': isInterested,
        'isRegistered': isRegistered,
      };
}

class EventModel {
  final String id;
  final String clubId;
  final String name;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;
  final String? location;
  final List<String> tags;
  final String? eventBanner;
  final List<EventGuest> guest;
  final String? whoShouldAttend;
  final String? description;
  final int registrants;
  final int likes;
  final List<String> additionalLinks;
  final List<String> feedback;
  final List<EventPOC> poc;
  final String? clubName;
  final EventStats? stats;
  final EventUserStatus? userStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  EventModel({
    required this.id,
    required this.clubId,
    required this.name,
    this.status = 'DRAFT',
    required this.startTime,
    required this.endTime,
    required this.date,
    this.location,
    this.tags = const [],
    this.eventBanner,
    this.guest = const [],
    this.whoShouldAttend,
    this.description,
    this.registrants = 0,
    this.likes = 0,
    this.additionalLinks = const [],
    this.feedback = const [],
    this.poc = const [],
    this.clubName,
    this.stats,
    this.userStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // Backward-compatibility getters
  String get title => name;
  String? get imageUrl => eventBanner;
  String? get compressedImageUrl => eventBanner;
  String? get venue => location;
  DateTime get startDateTime => startTime;
  DateTime get endDateTime => endTime;
  String get clubOrg => clubName ?? '';
  String get board => tags.isNotEmpty ? tags.first : '';
  List<String> get categories => tags;

  EventModel copyWith({
    String? id,
    String? clubId,
    String? name,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? date,
    String? location,
    List<String>? tags,
    String? eventBanner,
    List<EventGuest>? guest,
    String? whoShouldAttend,
    String? description,
    int? registrants,
    int? likes,
    List<String>? additionalLinks,
    List<String>? feedback,
    List<EventPOC>? poc,
    String? clubName,
    EventStats? stats,
    EventUserStatus? userStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      EventModel(
        id: id ?? this.id,
        clubId: clubId ?? this.clubId,
        name: name ?? this.name,
        status: status ?? this.status,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        date: date ?? this.date,
        location: location ?? this.location,
        tags: tags ?? this.tags,
        eventBanner: eventBanner ?? this.eventBanner,
        guest: guest ?? this.guest,
        whoShouldAttend: whoShouldAttend ?? this.whoShouldAttend,
        description: description ?? this.description,
        registrants: registrants ?? this.registrants,
        likes: likes ?? this.likes,
        additionalLinks: additionalLinks ?? this.additionalLinks,
        feedback: feedback ?? this.feedback,
        poc: poc ?? this.poc,
        clubName: clubName ?? this.clubName,
        stats: stats ?? this.stats,
        userStatus: userStatus ?? this.userStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory EventModel.fromRawJson(String str) =>
      EventModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    final clubIdVal = json['club_id'] is Map
        ? (json['club_id']['_id'] as String? ?? '')
        : (json['club_id'] as String? ?? '');

    final tagsList = (json['Tags'] as List<dynamic>?) ??
        (json['tags'] as List<dynamic>?) ??
        (json['categories'] as List<dynamic>?);

    final guestList = (json['guest'] as List<dynamic>?) ??
        (json['guests'] as List<dynamic>?);

    final pocList = (json['POC'] as List<dynamic>?) ??
        (json['poc'] as List<dynamic>?);

    final additionalLinksList = (json['additionalLinks'] as List<dynamic>?);
    final feedbackList = (json['Feedback'] as List<dynamic>?) ??
        (json['feedback'] as List<dynamic>?);

    return EventModel(
      id: (json['_id'] as String?) ?? (json['event_id'] as String?) ?? '',
      clubId: clubIdVal,
      name: (json['Name'] as String?) ??
          (json['name'] as String?) ??
          (json['title'] as String?) ??
          '',
      status: (json['status'] as String?) ?? 'DRAFT',
      startTime: parseDateTime(json['startTime'] ?? json['startDateTime']),
      endTime: parseDateTime(json['endTime'] ?? json['endDateTime']),
      date: parseDateTime(json['Date'] ?? json['date'] ?? json['startTime'] ?? json['startDateTime']),
      location: (json['Location'] as String?) ??
          (json['location'] as String?) ??
          (json['venue'] as String?),
      tags: tagsList?.map((e) => e.toString()).toList() ?? const [],
      eventBanner: (json['eventBanner'] as String?) ??
          (json['imageURL'] as String?) ??
          (json['compressedImageURL'] as String?),
      guest: guestList
              ?.map((e) => EventGuest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      whoShouldAttend: (json['whoShouldAttend'] as String?),
      description: (json['Description'] as String?) ??
          (json['description'] as String?),
      registrants: (json['Registrants'] as num?)?.toInt() ?? 0,
      likes: (json['Likes'] as num?)?.toInt() ?? 0,
      additionalLinks: additionalLinksList
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      feedback: feedbackList?.map((e) => e.toString()).toList() ?? const [],
      poc: pocList
              ?.map((e) => EventPOC.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      clubName: (json['clubName'] as String?) ??
          (json['club_org'] as String?) ??
          (json['club_id'] is Map ? json['club_id']['clubName'] as String? : null),
      stats: json['stats'] != null && json['stats'] is Map
          ? EventStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      userStatus: json['userStatus'] != null && json['userStatus'] is Map
          ? EventUserStatus.fromJson(
              json['userStatus'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      v: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'club_id': clubId,
        'Name': name,
        'status': status,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'Date': date.toIso8601String(),
        if (location != null) 'Location': location,
        'Tags': tags,
        if (eventBanner != null) 'eventBanner': eventBanner,
        'guest': guest.map((e) => e.toJson()).toList(),
        if (whoShouldAttend != null) 'whoShouldAttend': whoShouldAttend,
        if (description != null) 'Description': description,
        'Registrants': registrants,
        'Likes': likes,
        'additionalLinks': additionalLinks,
        'Feedback': feedback,
        'POC': poc.map((e) => e.toJson()).toList(),
        if (clubName != null) 'clubName': clubName,
        if (stats != null) 'stats': stats!.toJson(),
        if (userStatus != null) 'userStatus': userStatus!.toJson(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        if (v != null) '__v': v,
      };
}
