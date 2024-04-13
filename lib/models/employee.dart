class Employee {
  String id;
  List<String> authorizationsId;
  String name;
  String thirdCompanyId;
  String visitorCompany;
  String role;
  int number;
  String bloodType;
  String cpf;
  String email;
  String area;
  String lastAreaFound;
  DateTime lastTimeFound;
  bool isBlocked;
  bool documentsOk;
  String blockReason;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  Employee({
    required this.id,
    required this.authorizationsId,
    required this.name,
    required this.thirdCompanyId,
    required this.visitorCompany,
    required this.role,
    required this.number,
    required this.bloodType,
    required this.cpf,
    required this.email,
    required this.area,
    required this.lastAreaFound,
    required this.lastTimeFound,
    required this.isBlocked,
    required this.documentsOk,
    required this.blockReason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id']
          .toString(), // Assuming 'id' can be non-null but making sure it's a string.
      authorizationsId: json['authorizations_id'] != null
          ? List<String>.from(json['authorizations_id'])
          : [],
      name: json['name'] ?? '', // Provides an empty string if null.
      thirdCompanyId: json['third_company_id'] ?? '',
      visitorCompany: json['visitor_company'] ?? '',
      role: json['role'] ?? '',
      number: json['number'] ??
          0, // Assuming 'number' is an int, provide a default value if null.
      bloodType: json['blood_type'] ?? '',
      cpf: json['cpf'] ?? '',
      email: json['email'] ?? '',
      area: json['area'] ?? '',
      lastAreaFound: json['last_area_found'] ?? '',
      lastTimeFound: json['last_time_found'] != null
          ? DateTime.parse(json['last_time_found'])
          : DateTime.now(), // Handle DateTime parsing with a fallback.
      isBlocked: json['is_blocked'] ??
          false, // Assuming 'is_blocked' is a boolean, provide a default value if null.
      documentsOk: json['documents_ok'] ?? false,
      blockReason: json['block_reason'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorizations_id': authorizationsId,
      'name': name,
      'third_company_id': thirdCompanyId,
      'visitor_company': visitorCompany,
      'role': role,
      'number': number,
      'blood_type': bloodType,
      'cpf': cpf,
      'email': email,
      'area': area,
      'last_area_found': lastAreaFound,
      'last_time_found': lastTimeFound.toIso8601String(),
      'is_blocked': isBlocked,
      'documents_ok': documentsOk,
      'block_reason': blockReason,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }

  Employee copyWith({
    String? id,
    List<String>? authorizationsId,
    String? name,
    String? thirdCompanyId,
    String? visitorCompany,
    String? role,
    int? number,
    String? bloodType,
    String? cpf,
    String? email,
    String? area,
    String? lastAreaFound,
    DateTime? lastTimeFound,
    bool? isBlocked,
    bool? documentsOk,
    bool? isOnboard,
    String? blockReason,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Employee(
      id: id ?? this.id,
      authorizationsId: authorizationsId ?? this.authorizationsId,
      name: name ?? this.name,
      thirdCompanyId: thirdCompanyId ?? this.thirdCompanyId,
      visitorCompany: visitorCompany ?? this.visitorCompany,
      role: role ?? this.role,
      number: number ?? this.number,
      bloodType: bloodType ?? this.bloodType,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      area: area ?? this.area,
      lastAreaFound: lastAreaFound ?? this.lastAreaFound,
      lastTimeFound: lastTimeFound ?? this.lastTimeFound,
      isBlocked: isBlocked ?? this.isBlocked,
      documentsOk: documentsOk ?? this.documentsOk,
      blockReason: blockReason ?? this.blockReason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}
