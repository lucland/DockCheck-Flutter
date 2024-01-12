class User {
  String id;
  List<String> authorizationsId;
  String name;
  String company;
  String role;
  String project;
  int number;
  String bloodType;
  String cpf;
  DateTime aso;
  String asoDocument;
  bool hasAso;
  DateTime nr34;
  String nr34Document;
  bool hasNr34;
  DateTime nr35;
  String nr35Document;
  bool hasNr35;
  DateTime nr33;
  String nr33Document;
  bool hasNr33;
  DateTime nr10;
  String nr10Document;
  bool hasNr10;
  String email;
  String area;
  bool isAdmin;
  bool isVisitor;
  bool isPortalo;
  bool isCrew;
  bool isOnboarded;
  bool isBlocked;
  String blockReason;
  String iTag;
  String picture;
  String typeJob;
  DateTime startJob;
  DateTime endJob;
  String username;
  String salt;
  String hash;
  String status;

  User({
    required this.id,
    required this.authorizationsId,
    required this.name,
    required this.company,
    required this.role,
    required this.project,
    required this.number,
    required this.bloodType,
    required this.cpf,
    required this.aso,
    required this.asoDocument,
    required this.hasAso,
    required this.nr34,
    required this.nr34Document,
    required this.hasNr34,
    required this.nr35,
    required this.nr35Document,
    required this.hasNr35,
    required this.nr33,
    required this.nr33Document,
    required this.hasNr33,
    required this.nr10,
    required this.nr10Document,
    required this.hasNr10,
    required this.email,
    required this.area,
    required this.isAdmin,
    required this.isVisitor,
    required this.isPortalo,
    required this.isCrew,
    required this.isOnboarded,
    required this.isBlocked,
    required this.blockReason,
    required this.iTag,
    required this.picture,
    required this.typeJob,
    required this.startJob,
    required this.endJob,
    required this.username,
    required this.salt,
    required this.hash,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      authorizationsId: List<String>.from(json['authorizations_id']),
      name: json['name'],
      company: json['company'],
      role: json['role'],
      project: json['project'],
      number: json['number'],
      bloodType: json['blood_type'],
      cpf: json['cpf'],
      aso: DateTime.parse(json['aso']),
      asoDocument: json['aso_document'],
      hasAso: json['has_aso'],
      nr34: DateTime.parse(json['nr34']),
      nr34Document: json['nr34_document'],
      hasNr34: json['has_nr34'],
      nr35: DateTime.parse(json['nr35']),
      nr35Document: json['nr35_document'],
      hasNr35: json['has_nr35'],
      nr33: DateTime.parse(json['nr33']),
      nr33Document: json['nr33_document'],
      hasNr33: json['has_nr33'],
      nr10: DateTime.parse(json['nr10']),
      nr10Document: json['nr10_document'],
      hasNr10: json['has_nr10'],
      email: json['email'],
      area: json['area'],
      isAdmin: json['is_admin'],
      isVisitor: json['is_visitor'],
      isPortalo: json['is_portalo'],
      isCrew: json['is_crew'],
      isOnboarded: json['is_onboarded'],
      isBlocked: json['is_blocked'],
      blockReason: json['block_reason'],
      iTag: json['itag'],
      picture: json['picture'],
      typeJob: json['type_job'],
      startJob: DateTime.parse(json['start_job']),
      endJob: DateTime.parse(json['end_job']),
      username: json['username'],
      salt: json['salt'],
      hash: json['hash'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorizations_id': authorizationsId,
      'name': name,
      'company': company,
      'role': role,
      'project': project,
      'number': number,
      'blood_type': bloodType,
      'cpf': cpf,
      'aso': aso.toIso8601String(),
      'aso_document': asoDocument,
      'has_aso': hasAso,
      'nr34': nr34.toIso8601String(),
      'nr34_document': nr34Document,
      'has_nr34': hasNr34,
      'nr35': nr35.toIso8601String(),
      'nr35_document': nr35Document,
      'has_nr35': hasNr35,
      'nr33': nr33.toIso8601String(),
      'nr33_document': nr33Document,
      'has_nr33': hasNr33,
      'nr10': nr10.toIso8601String(),
      'nr10_document': nr10Document,
      'has_nr10': hasNr10,
      'email': email,
      'area': area,
      'is_admin': isAdmin,
      'is_visitor': isVisitor,
      'is_portalo': isPortalo,
      'is_crew': isCrew,
      'is_onboarded': isOnboarded,
      'is_blocked': isBlocked,
      'block_reason': blockReason,
      'itag': iTag,
      'picture': picture,
      'type_job': typeJob,
      'start_job': startJob.toIso8601String(),
      'end_job': endJob.toIso8601String(),
      'username': username,
      'salt': salt,
      'hash': hash,
      'status': status,
    };
  }

  User copyWith({
    String? id,
    List<String>? authorizationsId,
    String? name,
    String? company,
    String? role,
    String? project,
    int? number,
    String? bloodType,
    String? cpf,
    DateTime? aso,
    String? asoDocument,
    bool? hasAso,
    DateTime? nr34,
    String? nr34Document,
    bool? hasNr34,
    DateTime? nr35,
    String? nr35Document,
    bool? hasNr35,
    DateTime? nr33,
    String? nr33Document,
    bool? hasNr33,
    DateTime? nr10,
    String? nr10Document,
    bool? hasNr10,
    String? email,
    String? area,
    bool? isAdmin,
    bool? isVisitor,
    bool? isPortalo,
    bool? isCrew,
    bool? isOnboarded,
    bool? isBlocked,
    String? blockReason,
    String? iTag,
    String? picture,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? events,
    String? typeJob,
    DateTime? startJob,
    DateTime? endJob,
    String? username,
    String? salt,
    String? hash,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      authorizationsId: authorizationsId ?? this.authorizationsId,
      name: name ?? this.name,
      company: company ?? this.company,
      role: role ?? this.role,
      project: project ?? this.project,
      number: number ?? this.number,
      bloodType: bloodType ?? this.bloodType,
      cpf: cpf ?? this.cpf,
      aso: aso ?? this.aso,
      asoDocument: asoDocument ?? this.asoDocument,
      hasAso: hasAso ?? this.hasAso,
      nr34: nr34 ?? this.nr34,
      nr34Document: nr34Document ?? this.nr34Document,
      hasNr34: hasNr34 ?? this.hasNr34,
      nr35: nr35 ?? this.nr35,
      nr35Document: nr35Document ?? this.nr35Document,
      hasNr35: hasNr35 ?? this.hasNr35,
      nr33: nr33 ?? this.nr33,
      nr33Document: nr33Document ?? this.nr33Document,
      hasNr33: hasNr33 ?? this.hasNr33,
      nr10: nr10 ?? this.nr10,
      nr10Document: nr10Document ?? this.nr10Document,
      hasNr10: hasNr10 ?? this.hasNr10,
      email: email ?? this.email,
      area: area ?? this.area,
      isAdmin: isAdmin ?? this.isAdmin,
      isVisitor: isVisitor ?? this.isVisitor,
      isPortalo: isPortalo ?? this.isPortalo,
      isCrew: isCrew ?? this.isCrew,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isBlocked: isBlocked ?? this.isBlocked,
      blockReason: blockReason ?? this.blockReason,
      iTag: iTag ?? this.iTag,
      picture: picture ?? this.picture,
      typeJob: typeJob ?? this.typeJob,
      startJob: startJob ?? this.startJob,
      endJob: endJob ?? this.endJob,
      username: username ?? this.username,
      salt: salt ?? this.salt,
      hash: hash ?? this.hash,
      status: status ?? this.status,
    );
  }
}
