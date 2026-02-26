class TransportMethod {
  final String method;
  final String recommendation;
  final String details;
  final bool hasCabSharing;

  const TransportMethod({
    required this.method,
    this.recommendation = '',
    required this.details,
    this.hasCabSharing = false,
  });

  factory TransportMethod.fromJson(Map<String, dynamic> json) {
    return TransportMethod(
      method: json['method'] ?? '',
      recommendation: json['recommendation'] ?? '',
      details: json['details'] ?? '',
      hasCabSharing: json['hasCabSharing'] ?? false,
    );
  }
}

class TravelGuideModel {
  final String id;
  final String place;
  final String iconType;
  final String description;
  final List<TransportMethod> transportMethods;

  const TravelGuideModel({
    required this.id,
    required this.place,
    required this.iconType,
    this.description = '',
    this.transportMethods = const [],
  });

  factory TravelGuideModel.fromJson(Map<String, dynamic> json) {
    return TravelGuideModel(
      id: json['_id'] ?? '',
      place: json['place'] ?? '',
      iconType: json['iconType'] ?? 'other',
      description: json['description'] ?? '',
      transportMethods:
          (json['transportMethods'] as List<dynamic>?)
              ?.map((e) => TransportMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
