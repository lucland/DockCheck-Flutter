class Beacon {
  final int rssi;
  final DateTime found;
  final String userId;
  final DateTime updatedAt;
  final String id;
  late final String status;

  Beacon({
    required this.rssi,
    required this.found,
    required this.userId,
    required this.updatedAt,
    required this.id,
    required this.status,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      rssi: json['rssi'] as int,
      found: DateTime.parse(json['found']),
      userId: json['user_id'] as String,
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rssi': rssi,
      'found': found.toIso8601String(),
      'user_id': userId,
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
      'status': status,
    };
  }

  Beacon copyWith({
    int? rssi,
    DateTime? found,
    String? userId,
    DateTime? updatedAt,
    String? id,
    String? status,
  }) {
    return Beacon(
      rssi: rssi ?? this.rssi,
      found: found ?? this.found,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
