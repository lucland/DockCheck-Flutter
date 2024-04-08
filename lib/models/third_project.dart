class ThirdProject {
  String id;
  String name;
  DateTime dateStart;
  DateTime dateEnd;
  DateTime updatedAt;
  String status;
  String thirdCompanyId;
  String projectId;
  List<String> allowedAreasId;
  List<String> employeesId;
  bool isDocking;

  ThirdProject({
    required this.id,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.updatedAt,
    required this.status,
    required this.thirdCompanyId,
    required this.projectId,
    required this.allowedAreasId,
    required this.employeesId,
    required this.isDocking,
  });

  factory ThirdProject.fromJson(Map<String, dynamic> json) {
    return ThirdProject(
      id: json['id'],
      name: json['name'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: DateTime.parse(json['date_end']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
      thirdCompanyId: json['third_company_id'],
      projectId: json['project_id'],
      allowedAreasId: List<String>.from(json['allowed_areas_id']),
      employeesId: List<String>.from(json['employees_id']),
      isDocking: json['is_docking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_start': dateStart.toIso8601String(),
      'date_end': dateEnd.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'third_company_id': thirdCompanyId,
      'project_id': projectId,
      'allowed_areas_id': allowedAreasId,
      'employees_id': employeesId,
      'is_docking': isDocking,
    };
  }

  ThirdProject copyWith({
    String? id,
    String? name,
    DateTime? dateStart,
    DateTime? dateEnd,
    DateTime? updatedAt,
    String? status,
    String? thirdCompanyId,
    String? projectId,
    List<String>? allowedAreasId,
    List<String>? employeesId,
    bool? isDocking,
  }) {
    return ThirdProject(
      id: id ?? this.id,
      name: name ?? this.name,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      thirdCompanyId: thirdCompanyId ?? this.thirdCompanyId,
      projectId: projectId ?? this.projectId,
      allowedAreasId: allowedAreasId ?? this.allowedAreasId,
      employeesId: employeesId ?? this.employeesId,
      isDocking: isDocking ?? this.isDocking,
    );
  }
}
