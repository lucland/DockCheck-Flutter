class Beacon {
  final int itag;
  final bool isValid;
  final String userId;
  final String id;
  late final String status;

  Beacon({
    required this.itag,
    required this.isValid,
    required this.userId,
    required this.id,
    required this.status,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      itag: json['itag'] as int,
      isValid: json['is_valid'] as bool,
      userId: json['user_id'] as String,
      id: json['id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itag': itag,
      'is_valid': isValid,
      'user_id': userId,
      'id': id,
      'status': status,
    };
  }

  Beacon copyWith({
    int? itag,
    bool? isValid,
    String? userId,
    String? id,
    String? status,
  }) {
    return Beacon(
      itag: itag ?? this.itag,
      isValid: isValid ?? this.isValid,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
