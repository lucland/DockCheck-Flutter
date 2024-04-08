class Event {
  String id;
  String employeeId;
  DateTime timestamp;
  String projectId;
  int action;
  String sensorId;
  String status;
  String beaconId;

  Event({
    required this.id,
    required this.employeeId,
    required this.timestamp,
    required this.projectId,
    required this.action,
    required this.sensorId,
    required this.status,
    required this.beaconId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      employeeId: json['employee_id'],
      timestamp: DateTime.parse(json['timestamp']),
      projectId: json['project_id'],
      action: json['action'],
      sensorId: json['sensor_id'],
      status: json['status'],
      beaconId: json['beacon_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'timestamp': timestamp.toIso8601String(),
      'project_id': projectId,
      'action': action,
      'sensor_id': sensorId,
      'status': status,
      'beacon_id': beaconId,
    };
  }

  Event copyWith({
    String? id,
    String? employeeId,
    DateTime? timestamp,
    String? projectId,
    int? action,
    String? sensorId,
    String? status,
    String? beaconId,
  }) {
    return Event(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      timestamp: timestamp ?? this.timestamp,
      projectId: projectId ?? this.projectId,
      action: action ?? this.action,
      sensorId: sensorId ?? this.sensorId,
      status: status ?? this.status,
      beaconId: beaconId ?? this.beaconId,
    );
  }
}
