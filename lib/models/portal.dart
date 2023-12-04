class Portal {
  String name;
  String id;
  String vesselId;
  int cameraStatus;
  String cameraIp;
  int rfidStatus;
  String rfidIp;
  DateTime createdAt;
  DateTime updatedAt;

  Portal({
    required this.name,
    required this.id,
    required this.vesselId,
    required this.cameraStatus,
    required this.cameraIp,
    required this.rfidStatus,
    required this.rfidIp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Portal.fromJson(Map<String, dynamic> json) {
    return Portal(
      name: json['name'],
      id: json['id'],
      vesselId: json['vessel_id'],
      cameraStatus: json['camera_status'],
      cameraIp: json['camera_ip'],
      rfidStatus: json['rfid_status'],
      rfidIp: json['rfid_ip'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'vessel_id': vesselId,
      'camera_status': cameraStatus,
      'camera_ip': cameraIp,
      'rfid_status': rfidStatus,
      'rfid_ip': rfidIp,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
