class Document {
  String id;
  String type;
  DateTime expirationDate;
  String path;
  String employeeId;
  String status;

  Document({
    required this.id,
    required this.type,
    required this.expirationDate,
    required this.path,
    required this.employeeId,
    required this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      type: json['type'],
      expirationDate: DateTime.parse(json['expiration_date']),
      path: json['path'],
      employeeId: json['employee_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'expiration_date': expirationDate.toIso8601String(),
      'path': path,
      'employee_id': employeeId,
      'status': status,
    };
  }

  Document copyWith({
    String? id,
    String? type,
    DateTime? expirationDate,
    String? path,
    String? employeeId,
    String? status,
  }) {
    return Document(
      id: id ?? this.id,
      type: type ?? this.type,
      expirationDate: expirationDate ?? this.expirationDate,
      path: path ?? this.path,
      employeeId: employeeId ?? this.employeeId,
      status: status ?? this.status,
    );
  }
}
