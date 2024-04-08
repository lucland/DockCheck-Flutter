class Project {
  String id;
  String name;
  DateTime dateStart;
  DateTime dateEnd;
  String vesselId;
  String companyId;
  List<String> thirdCompaniesId;
  List<String> adminsId;
  List<String> employeesId;
  List<String> areasId;
  String address;
  bool isDocking;
  String status;
  String userId;

  Project({
    required this.id,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.vesselId,
    required this.companyId,
    required this.thirdCompaniesId,
    required this.adminsId,
    required this.employeesId,
    required this.areasId,
    required this.address,
    required this.isDocking,
    required this.status,
    required this.userId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: DateTime.parse(json['date_end']),
      vesselId: json['vessel_id'],
      companyId: json['company_id'],
      thirdCompaniesId: List<String>.from(json['third_companies_id']),
      adminsId: List<String>.from(json['admins_id']),
      employeesId: List<String>.from(json['employees_id']),
      areasId: List<String>.from(json['areas_id']),
      address: json['address'],
      isDocking: json['is_docking'],
      status: json['status'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_start': dateStart.toIso8601String(),
      'date_end': dateEnd.toIso8601String(),
      'vessel_id': vesselId,
      'company_id': companyId,
      'third_companies_id': thirdCompaniesId,
      'admins_id': adminsId,
      'employees_id': employeesId,
      'areas_id': areasId,
      'address': address,
      'is_docking': isDocking,
      'status': status,
      'user_id': userId,
    };
  }

  Project copyWith({
    String? id,
    String? name,
    DateTime? dateStart,
    DateTime? dateEnd,
    String? vesselId,
    String? companyId,
    List<String>? thirdCompaniesId,
    List<String>? adminsId,
    List<String>? employeesId,
    List<String>? areasId,
    String? address,
    bool? isDocking,
    String? status,
    String? userId,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      vesselId: vesselId ?? this.vesselId,
      companyId: companyId ?? this.companyId,
      thirdCompaniesId: thirdCompaniesId ?? this.thirdCompaniesId,
      adminsId: adminsId ?? this.adminsId,
      employeesId: employeesId ?? this.employeesId,
      areasId: areasId ?? this.areasId,
      address: address ?? this.address,
      isDocking: isDocking ?? this.isDocking,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
