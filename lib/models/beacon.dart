class Beacon {
  String id;
  String itag;
  bool isValid;
  String employeeId;
  String status;

  Beacon({
    required this.id,
    required this.itag,
    required this.isValid,
    required this.employeeId,
    required this.status,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['id'],
      itag: json['itag'],
      isValid: json['is_valid'],
      employeeId: json['employee_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itag': itag,
      'is_valid': isValid,
      'employee_id': employeeId,
      'status': status,
    };
  }

  Beacon copyWith({
    String? id,
    String? itag,
    bool? isValid,
    String? employeeId,
    String? status,
  }) {
    return Beacon(
      id: id ?? this.id,
      itag: itag ?? this.itag,
      isValid: isValid ?? this.isValid,
      employeeId: employeeId ?? this.employeeId,
      status: status ?? this.status,
    );
  }
}
