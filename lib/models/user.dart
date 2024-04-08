class User {
  String id;
  String name;
  String companyId;
  String role;
  int number;
  String bloodType;
  String cpf;
  String email;
  bool isBlocked;
  String blockReason;
  bool canCreate;
  String username;
  String salt;
  String hash;
  String status;

  User({
    required this.id,
    required this.name,
    required this.companyId,
    required this.role,
    required this.number,
    required this.bloodType,
    required this.cpf,
    required this.email,
    required this.isBlocked,
    required this.blockReason,
    required this.canCreate,
    required this.username,
    required this.salt,
    required this.hash,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      companyId: json['company_id'],
      role: json['role'],
      number: json['number'],
      bloodType: json['blood_type'],
      cpf: json['cpf'],
      email: json['email'],
      isBlocked: json['is_blocked'],
      blockReason: json['block_reason'],
      canCreate: json['can_create'],
      username: json['username'],
      salt: json['salt'],
      hash: json['hash'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company_id': companyId,
      'role': role,
      'number': number,
      'blood_type': bloodType,
      'cpf': cpf,
      'email': email,
      'is_blocked': isBlocked,
      'block_reason': blockReason,
      'can_create': canCreate,
      'username': username,
      'salt': salt,
      'hash': hash,
      'status': status,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? companyId,
    String? role,
    int? number,
    String? bloodType,
    String? cpf,
    String? email,
    bool? isBlocked,
    String? blockReason,
    bool? canCreate,
    String? username,
    String? salt,
    String? hash,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
      number: number ?? this.number,
      bloodType: bloodType ?? this.bloodType,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      isBlocked: isBlocked ?? this.isBlocked,
      blockReason: blockReason ?? this.blockReason,
      canCreate: canCreate ?? this.canCreate,
      username: username ?? this.username,
      salt: salt ?? this.salt,
      hash: hash ?? this.hash,
      status: status ?? this.status,
    );
  }
}
