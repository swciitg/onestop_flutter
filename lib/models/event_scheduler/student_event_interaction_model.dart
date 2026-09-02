class EventFeedback {
  final int? rating;
  final String? comment;
  final String? suggestions;

  EventFeedback({
    this.rating,
    this.comment,
    this.suggestions,
  });

  factory EventFeedback.fromJson(Map<String, dynamic> json) => EventFeedback(
        rating: json['rating'] as int?,
        comment: json['comment'] as String?,
        suggestions: json['suggestions'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
        if (suggestions != null) 'suggestions': suggestions,
      };
}

class StudentEventInteractionModel {
  final String? id;
  final String studentId;
  final String eventId;
  final bool like;
  final EventFeedback? feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentEventInteractionModel({
    this.id,
    required this.studentId,
    required this.eventId,
    this.like = false,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentEventInteractionModel.fromJson(Map<String, dynamic> json) =>
      StudentEventInteractionModel(
        id: json['_id'] as String?,
        studentId: json['student_id'] is Map
            ? (json['student_id']['_id'] as String? ?? '')
            : (json['student_id'] as String? ?? ''),
        eventId: json['event_id'] is Map
            ? (json['event_id']['_id'] as String? ?? '')
            : (json['event_id'] as String? ?? ''),
        like: (json['like'] as bool?) ?? false,
        feedback: json['feedback'] != null && json['feedback'] is Map
            ? EventFeedback.fromJson(
                json['feedback'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        'student_id': studentId,
        'event_id': eventId,
        'like': like,
        if (feedback != null) 'feedback': feedback!.toJson(),
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
