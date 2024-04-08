class Picture {
  String id;
  String employeeId;
  String base64;
  String docPath;
  String status;

  Picture({
    required this.id,
    required this.employeeId,
    required this.base64,
    required this.docPath,
    required this.status,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      employeeId: json['employee_id'],
      base64: json['base_64'],
      docPath: json['doc_path'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'base_64': base64,
      'doc_path': docPath,
      'status': status,
    };
  }

  Picture copyWith({
    String? id,
    String? employeeId,
    String? base64,
    String? docPath,
    String? status,
  }) {
    return Picture(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      base64: base64 ?? this.base64,
      docPath: docPath ?? this.docPath,
      status: status ?? this.status,
    );
  }
}
