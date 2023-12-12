class Receptor {
  final List<String> beacons;
  final String vessel;
  final DateTime updatedAt;
  final String id;

  Receptor({
    required this.beacons,
    required this.vessel,
    required this.updatedAt,
    required this.id,
  });

  factory Receptor.fromJson(Map<String, dynamic> json) {
    return Receptor(
      beacons: List<String>.from(json['beacons'] as List),
      vessel: json['vessel'] as String,
      updatedAt: DateTime.parse(json['updated_at']),
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beacons': beacons,
      'vessel': vessel,
      'updated_at': updatedAt.toIso8601String(),
      'id': id,
    };
  }

  Receptor copyWith({
    List<String>? beacons,
    String? vessel,
    DateTime? updatedAt,
    String? id,
  }) {
    return Receptor(
      beacons: beacons ?? this.beacons,
      vessel: vessel ?? this.vessel,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }
}
