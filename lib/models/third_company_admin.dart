class ThirdCompanyAdmin {
  String id;
  String thirdCompanyId;
  String userId;

  ThirdCompanyAdmin({
    required this.id,
    required this.thirdCompanyId,
    required this.userId,
  });

  factory ThirdCompanyAdmin.fromJson(Map<String, dynamic> json) {
    return ThirdCompanyAdmin(
      id: json['id'],
      thirdCompanyId: json['third_company_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'third_company_id': thirdCompanyId,
      'user_id': userId,
    };
  }

  ThirdCompanyAdmin copyWith({
    String? id,
    String? thirdCompanyId,
    String? userId,
  }) {
    return ThirdCompanyAdmin(
      id: id ?? this.id,
      thirdCompanyId: thirdCompanyId ?? this.thirdCompanyId,
      userId: userId ?? this.userId,
    );
  }
}
