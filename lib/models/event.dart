class Event {
  String id;
  String portalId;
  String userId;
  DateTime timestamp;
  int direction;
  String picture;
  String vesselId;
  int action;
  bool manual;
  String justification;
  DateTime createdAt;
  DateTime updatedAt;
  String status;

  Event({
    required this.id,
    required this.portalId,
    required this.userId,
    required this.timestamp,
    required this.direction,
    required this.picture,
    required this.vesselId,
    required this.action,
    required this.manual,
    required this.justification,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      portalId: json['portal_id'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
      direction: json['direction'],
      picture: json['picture'],
      vesselId: json['vessel_id'],
      action: json['action'],
      manual: json['manual'],
      justification: json['justification'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'portal_id': portalId,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'direction': direction,
      'picture': picture,
      'vessel_id': vesselId,
      'action': action,
      'manual': manual,
      'justification': justification,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }

  Event copyWith({
    String? id,
    String? portalId,
    String? userId,
    DateTime? timestamp,
    int? direction,
    String? picture,
    String? vesselId,
    int? action,
    bool? manual,
    String? justification,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return Event(
      id: id ?? this.id,
      portalId: portalId ?? this.portalId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      direction: direction ?? this.direction,
      picture: picture ?? this.picture,
      vesselId: vesselId ?? this.vesselId,
      action: action ?? this.action,
      manual: manual ?? this.manual,
      justification: justification ?? this.justification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}
