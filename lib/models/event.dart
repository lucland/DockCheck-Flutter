class Event {
  String id;
  String portalId;
  String userId;
  DateTime timestamp;
  String beaconId;
  String vesselId;
  int action;
  String justification;
  String status;

  Event({
    required this.id,
    required this.portalId,
    required this.userId,
    required this.timestamp,
    required this.beaconId,
    required this.vesselId,
    required this.action,
    required this.justification,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      portalId: json['portal_id'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
      beaconId: json['beacon_id'],
      vesselId: json['vessel_id'],
      action: json['action'],
      justification: json['justification'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'portal_id': portalId,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'beacon_id': beaconId,
      'vessel_id': vesselId,
      'action': action,
      'justification': justification,
      'status': status,
    };
  }

  Event copyWith({
    String? id,
    String? portalId,
    String? userId,
    DateTime? timestamp,
    String? beaconId,
    String? vesselId,
    int? action,
    String? justification,
    String? status,
  }) {
    return Event(
      id: id ?? this.id,
      portalId: portalId ?? this.portalId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      beaconId: beaconId ?? this.beaconId,
      vesselId: vesselId ?? this.vesselId,
      action: action ?? this.action,
      justification: justification ?? this.justification,
      status: status ?? this.status,
    );
  }
}
