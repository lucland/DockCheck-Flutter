class Vessel {
  String id;
  String name;
  String companyId;
  List<String> crewId;
  int onboardedCount;
  List<String> areasId;
  String status;

  Vessel({
    required this.id,
    required this.name,
    required this.companyId,
    required this.crewId,
    required this.onboardedCount,
    required this.areasId,
    required this.status,
  });

  factory Vessel.fromJson(Map<String, dynamic> json) {
    return Vessel(
      id: json['id'],
      name: json['name'],
      companyId: json['company_id'],
      crewId: List<String>.from(json['crew_id']),
      onboardedCount: json['onboarded_count'],
      areasId: List<String>.from(json['areas_id']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company_id': companyId,
      'crew_id': crewId,
      'onboarded_count': onboardedCount,
      'areas_id': areasId,
      'status': status,
    };
  }

  Vessel copyWith({
    String? id,
    String? name,
    String? companyId,
    List<String>? crewId,
    int? onboardedCount,
    List<String>? areasId,
    String? status,
  }) {
    return Vessel(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      crewId: crewId ?? this.crewId,
      onboardedCount: onboardedCount ?? this.onboardedCount,
      areasId: areasId ?? this.areasId,
      status: status ?? this.status,
    );
  }
}
