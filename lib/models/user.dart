import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int numero;
  String identidade;
  String nome;
  String funcao;
  String email;
  String empresa;
  Timestamp ASO;
  Timestamp NR34;
  Timestamp NR10;
  Timestamp NR33;
  Timestamp NR35;
  String vessel;
  Timestamp dataInicial;
  Timestamp dataLimite;
  bool isVisitante;
  bool isAdmin;
  List<String> eventos;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool isBlocked;
  String area;
  String reason;
  bool isOnboarded;
  bool isSupervisor;

  User({
    required this.numero,
    required this.identidade,
    required this.nome,
    required this.funcao,
    required this.email,
    required this.empresa,
    required this.ASO,
    required this.NR34,
    required this.NR10,
    required this.NR33,
    required this.NR35,
    required this.vessel,
    required this.dataInicial,
    required this.dataLimite,
    required this.isVisitante,
    required this.isAdmin,
    required this.eventos,
    required this.createdAt,
    required this.updatedAt,
    required this.isBlocked,
    required this.area,
    required this.reason,
    required this.isOnboarded,
    required this.isSupervisor,
  });

  User copyWith({
    int? numero,
    String? identidade,
    String? nome,
    String? funcao,
    String? email,
    String? empresa,
    Timestamp? ASO,
    Timestamp? NR34,
    Timestamp? NR10,
    Timestamp? NR33,
    Timestamp? NR35,
    String? vessel,
    Timestamp? dataInicial,
    Timestamp? dataLimite,
    bool? isVisitante,
    bool? isAdmin,
    List<String>? eventos,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? isBlocked,
    String? area,
    String? reason,
    bool? isOnboarded,
    bool? isSupervisor,
  }) {
    return User(
      numero: numero ?? this.numero,
      identidade: identidade ?? this.identidade,
      nome: nome ?? this.nome,
      funcao: funcao ?? this.funcao,
      email: email ?? this.email,
      empresa: empresa ?? this.empresa,
      ASO: ASO ?? this.ASO,
      NR34: NR34 ?? this.NR34,
      NR10: NR10 ?? this.NR10,
      NR33: NR33 ?? this.NR33,
      NR35: NR35 ?? this.NR35,
      vessel: vessel ?? this.vessel,
      dataInicial: dataInicial ?? this.dataInicial,
      dataLimite: dataLimite ?? this.dataLimite,
      isVisitante: isVisitante ?? this.isVisitante,
      isAdmin: isAdmin ?? this.isAdmin,
      eventos: eventos ?? this.eventos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBlocked: isBlocked ?? this.isBlocked,
      area: area ?? this.area,
      reason: reason ?? this.reason,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isSupervisor: isSupervisor ?? this.isSupervisor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'identidade': identidade,
      'nome': nome,
      'funcao': funcao,
      'email': email,
      'empresa': empresa,
      'ASO': ASO,
      'NR34': NR34,
      'NR10': NR10,
      'NR33': NR33,
      'NR35': NR35,
      'vessel': vessel,
      'dataInicial': dataInicial,
      'dataLimite': dataLimite,
      'isVisitante': isVisitante,
      'isAdmin': isAdmin,
      'eventos': eventos,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isBlocked': isBlocked,
      'area': area,
      'reason': reason,
      'isOnboarded': isOnboarded,
      'isSupervisor': isSupervisor,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      numero: map['numero'],
      identidade: map['identidade'],
      nome: map['nome'],
      funcao: map['funcao'],
      email: map['email'],
      empresa: map['empresa'],
      ASO: map['ASO'],
      NR34: map['NR34'],
      NR10: map['NR10'],
      NR33: map['NR33'],
      NR35: map['NR35'],
      vessel: map['vessel'],
      dataInicial: map['dataInicial'],
      dataLimite: map['dataLimite'],
      isVisitante: map['isVisitante'],
      isAdmin: map['isAdmin'],
      eventos: List<String>.from(map['eventos']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      isBlocked: map['isBlocked'],
      area: map['area'],
      reason: map['reason'],
      isOnboarded: map['isOnboarded'],
      isSupervisor: map['isSupervisor'],
    );
  }

  String toDatabaseString() {
    return "$numero\r\n$nome\r\n$empresa\r\n$funcao\r\n$identidade\r\n$email\r\n$vessel\r\n$ASO\r\n$NR34\r\n$NR10\r\n$NR33\r\n$NR35\r\n$dataInicial\r\n$dataLimite";
  }
}
