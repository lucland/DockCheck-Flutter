class Empresa {
  String id;
  String nome;
  String logo;
  List<String> users;
  List<String> vessels;
  String createdAt;
  String updatedAt;

  Empresa({
    required this.id,
    required this.nome,
    required this.logo,
    required this.users,
    required this.vessels,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'logo': logo,
      'users': users,
      'vessels': vessels,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Empresa fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['id'],
      nome: map['nome'],
      logo: map['logo'],
      users: List<String>.from(map['users']),
      vessels: List<String>.from(map['vessels']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
