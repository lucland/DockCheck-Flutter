class CompanyAdmin {
  String id;
  String companyId;
  String userId;

  CompanyAdmin({
    required this.id,
    required this.companyId,
    required this.userId,
  });

  factory CompanyAdmin.fromJson(Map<String, dynamic> json) {
    return CompanyAdmin(
      id: json['id'],
      companyId: json['company_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'user_id': userId,
    };
  }

  CompanyAdmin copyWith({
    String? id,
    String? companyId,
    String? userId,
  }) {
    return CompanyAdmin(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      userId: userId ?? this.userId,
    );
  }
}
