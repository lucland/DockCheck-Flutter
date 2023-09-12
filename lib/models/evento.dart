class Evento {
  String id;
  String timestamp;
  String user;
  String local;
  String vessel;
  String createdAt;
  String updatedAt;

  Evento({
    required this.id,
    required this.timestamp,
    required this.user,
    required this.local,
    required this.vessel,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'user': user,
      'local': local,
      'vessel': vessel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Evento fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'],
      timestamp: map['timestamp'],
      user: map['user'],
      local: map['local'],
      vessel: map['vessel'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
