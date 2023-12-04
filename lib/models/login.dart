class Login {
  String id;
  String userId;
  DateTime timestamp;
  DateTime expiration;
  String system;
  DateTime createdAt;
  DateTime updatedAt;

  Login({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.expiration,
    required this.system,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
      expiration: DateTime.parse(json['expiration']),
      system: json['system'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'expiration': expiration.toIso8601String(),
      'system': system,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
