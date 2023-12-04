class Authorization {
  String id;
  String userId;
  String vesselId;
  DateTime expirationDate;

  Authorization(
      {required this.id,
      required this.userId,
      required this.vesselId,
      required this.expirationDate});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      id: json['id'],
      userId: json['user_id'],
      vesselId: json['vessel_id'],
      expirationDate: DateTime.parse(json['expiration_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vessel_id': vesselId,
      'expiration_date': expirationDate.toIso8601String(),
    };
  }
}
