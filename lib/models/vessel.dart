class Vessel {
  String id;
  String nome;
  int onBoarded;
  List<String> users;
  String createdAt;
  String updatedAt;

  Vessel({
    required this.id,
    required this.nome,
    required this.onBoarded,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'onBoarded': onBoarded,
      'users': users,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Vessel fromMap(Map<String, dynamic> map) {
    return Vessel(
      id: map['id'],
      nome: map['nome'],
      onBoarded: map['onBoarded'],
      users: List<String>.from(map['users']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
