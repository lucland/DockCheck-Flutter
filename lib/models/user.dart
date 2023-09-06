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

  String toDatabaseString() {
    return "$number\r\n$name\r\n$company\r\n$role\r\n$identity\r\n$email\r\n$vessel\r\n$aso\r\n$nr34\r\n$nr10\r\n$nr33\r\n$nr35\r\n$initialDate\r\n$finalDate";
  }
}
