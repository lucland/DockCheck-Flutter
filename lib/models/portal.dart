class Portal {
  String name;
  String id;
  String vesselId;
  int onBoardCount;
  String userId;
  DateTime lastEvent;
  String status;

  Portal({
    required this.name,
    required this.id,
    required this.vesselId,
    required this.onBoardCount,
    required this.userId,
    required this.lastEvent,
    required this.status,
  });

  factory Portal.fromJson(Map<String, dynamic> json) {
    return Portal(
      name: json['name'],
      id: json['id'],
      vesselId: json['vessel_id'],
      onBoardCount: json['onboard_count'],
      userId: json['user_id'],
      lastEvent: DateTime.parse(json['last_event']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'vessel_id': vesselId,
      'onboard_count': onBoardCount,
      'user_id': userId,
      'last_event': lastEvent.toIso8601String(),
      'status': status,
    };
  }
}
