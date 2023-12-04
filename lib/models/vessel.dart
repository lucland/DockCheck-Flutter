class Vessel {
  String name;
  String companyId;
  DateTime updatedAt;
  String id;
  List<String> admins;
  int onboardedCount;
  List<String> portals;

  Vessel({
    required this.name,
    required this.companyId,
    required this.updatedAt,
    required this.id,
    required this.admins,
    required this.onboardedCount,
    required this.portals,
  });

  factory Vessel.fromJson(Map<String, dynamic> json) {
    return Vessel(
      name: json['name'],
      companyId: json['company_id'],
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'],
      admins: List<String>.from(json['admins']),
      onboardedCount: json['onboarded_count'],
      portals: List<String>.from(json['portals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'company_id': companyId,
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
      'admins': admins,
      'onboarded_count': onboardedCount,
      'portals': portals,
    };
  }
}
