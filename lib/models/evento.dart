import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  String acao;
  String user;
  String vessel;
  Timestamp createdAt;

  Evento({
    required this.acao,
    required this.user,
    required this.vessel,
    required this.createdAt,
  });

  Evento copyWith({
    String? acao,
    String? user,
    String? vessel,
    Timestamp? createdAt,
  }) {
    return Evento(
      acao: acao ?? this.acao,
      user: user ?? this.user,
      vessel: vessel ?? this.vessel,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acao': acao,
      'user': user,
      'vessel': vessel,
      'createdAt': createdAt,
    };
  }

  static Evento fromMap(Map<String, dynamic> map) {
    return Evento(
      acao: map['acao'],
      user: map['user'],
      vessel: map['vessel'],
      createdAt: map['createdAt'],
    );
  }
}
