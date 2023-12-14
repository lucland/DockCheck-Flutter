class Company {
  String name;
  String logo;
  List<String> supervisors;
  List<String> vessels;
  DateTime updatedAt;
  String id;
  DateTime expirationDate;
  String status;

  Company({
    required this.name,
    required this.logo,
    required this.supervisors,
    required this.vessels,
    required this.updatedAt,
    required this.id,
    required this.expirationDate,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      logo: json['logo'],
      supervisors: List<String>.from(json['supervisors']),
      vessels: List<String>.from(json['vessels']),
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'],
      expirationDate: DateTime.parse(json['expiration_date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'supervisors': supervisors,
      'vessels': vessels,
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
      'expiration_date': expirationDate.toIso8601String(),
      'status': status,
    };
  }
}
