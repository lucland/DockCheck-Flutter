class User {
  final DateTime aso;
  final DateTime checkIn;
  final String checkInValidation;
  final DateTime checkOut;
  final String checkOutValidation;
  final String company;
  final String email;
  final String identity;
  final bool isAdmin;
  final bool isBlocked;
  final bool isVisitor;
  final List<String> log;
  final String name;
  final DateTime nr10;
  final DateTime nr33;
  final DateTime nr34;
  final DateTime nr35;
  final int number;
  final String project;
  final String reason;
  final String role;
  final String user;
  final String vessel;
  final bool isOnboarded;
  final bool isConves;
  final bool isPraca;
  final bool isCasario;
  final DateTime initialDate;
  final DateTime finalDate;

  User({
    required this.aso,
    required this.checkIn,
    required this.checkInValidation,
    required this.checkOut,
    required this.checkOutValidation,
    required this.company,
    required this.email,
    required this.identity,
    required this.isAdmin,
    required this.isBlocked,
    required this.isVisitor,
    required this.log,
    required this.name,
    required this.nr10,
    required this.nr33,
    required this.nr34,
    required this.nr35,
    required this.number,
    required this.project,
    required this.reason,
    required this.role,
    required this.user,
    required this.vessel,
    required this.isOnboarded,
    required this.isConves,
    required this.isPraca,
    required this.isCasario,
    required this.initialDate,
    required this.finalDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'aso': aso,
      'checkIn': checkIn,
      'checkInValidation': checkInValidation,
      'checkOut': checkOut,
      'checkOutValidation': checkOutValidation,
      'company': company,
      'email': email,
      'identity': identity,
      'isAdmin': isAdmin,
      'isBlocked': isBlocked,
      'isVisitor': isVisitor,
      'log': log,
      'name': name,
      'nr10': nr10,
      'nr33': nr33,
      'nr34': nr34,
      'nr35': nr35,
      'number': number,
      'project': project,
      'reason': reason,
      'role': role,
      'user': user,
      'vessel': vessel,
      'isOnboarded': isOnboarded,
      'isConves': isConves,
      'isPraca': isPraca,
      'isCasario': isCasario,
      'initialDate': initialDate,
      'finalDate': finalDate,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      aso: map['aso'].toDate(),
      checkIn: map['checkIn'].toDate(),
      checkInValidation: map['checkInValidation'],
      checkOut: map['checkOut'].toDate(),
      checkOutValidation: map['checkOutValidation'],
      company: map['company'],
      email: map['email'],
      identity: map['identity'],
      isAdmin: map['isAdmin'],
      isBlocked: map['isBlocked'],
      isVisitor: map['isVisitor'],
      log: List<String>.from(map['log']),
      name: map['name'],
      nr10: map['nr10'].toDate(),
      nr33: map['nr33'].toDate(),
      nr34: map['nr34'].toDate(),
      nr35: map['nr35'].toDate(),
      number: map['number'],
      project: map['project'],
      reason: map['reason'],
      role: map['role'],
      user: map['user'],
      vessel: map['vessel'],
      isOnboarded: map['isOnboarded'],
      isConves: map['isConves'],
      isPraca: map['isPraca'],
      isCasario: map['isCasario'],
      initialDate: map['initialDate'].toDate(),
      finalDate: map['finalDate'].toDate(),
    );
  }

  String toDatabaseString() {
    return "$number\r\n$name\r\n$company\r\n$role\r\n$identity\r\n$email\r\n$vessel\r\n$aso\r\n$nr34\r\n$nr10\r\n$nr33\r\n$nr35\r\n$initialDate\r\n$finalDate";
  }
}
