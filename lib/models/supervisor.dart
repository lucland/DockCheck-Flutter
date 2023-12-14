class Supervisor {
  String name;
  String username;
  String salt;
  String hash;
  String companyId;
  String id;
  DateTime updatedAt;
  String status;

  Supervisor({
    required this.name,
    required this.username,
    required this.salt,
    required this.hash,
    required this.companyId,
    required this.id,
    required this.updatedAt,
    required this.status,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      name: json['name'],
      username: json['username'],
      salt: json['salt'],
      hash: json['hash'],
      companyId: json['company_id'],
      id: json['id'],
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'salt': salt,
      'hash': hash,
      'company_id': companyId,
      'id': id,
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }
}
