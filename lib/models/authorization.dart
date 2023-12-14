class Authorization {
  String id;
  String userId;
  String vesselId;
  DateTime expirationDate;
  String status;

  Authorization(
      {required this.id,
      required this.userId,
      required this.vesselId,
      required this.expirationDate,
      required this.status});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      id: json['id'],
      userId: json['user_id'],
      vesselId: json['vessel_id'],
      expirationDate: DateTime.parse(json['expiration_date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vessel_id': vesselId,
      'expiration_date': expirationDate.toIso8601String(),
      'status': status,
    };
  }
}
