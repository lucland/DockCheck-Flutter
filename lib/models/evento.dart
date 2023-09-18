import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  String acao;
  Timestamp timestamp;
  String user;
  String vessel;
  Timestamp createdAt;
  Timestamp updatedAt;

  Evento({
    required this.acao,
    required this.timestamp,
    required this.user,
    required this.vessel,
    required this.createdAt,
    required this.updatedAt,
  });

  Evento copyWith({
    String? acao,
    Timestamp? timestamp,
    String? user,
    String? vessel,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Evento(
      acao: acao ?? this.acao,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
      vessel: vessel ?? this.vessel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acao': acao,
      'timestamp': timestamp,
      'user': user,
      'vessel': vessel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Evento fromMap(Map<String, dynamic> map) {
    return Evento(
      acao: map['acao'],
      timestamp: map['timestamp'],
      user: map['user'],
      vessel: map['vessel'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
