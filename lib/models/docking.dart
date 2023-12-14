class Docking {
  int onboardedCount;
  String id;
  DateTime dateStart;
  DateTime dateEnd;
  List<String> admins;
  String vesselId;
  DateTime updatedAt;
  double draftMeters;
  String status;

  Docking({
    required this.onboardedCount,
    required this.id,
    required this.dateStart,
    required this.dateEnd,
    required this.admins,
    required this.vesselId,
    required this.updatedAt,
    required this.draftMeters,
    required this.status,
  });

  factory Docking.fromJson(Map<String, dynamic> json) {
    return Docking(
      onboardedCount: json['onboarded_count'],
      id: json['id'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: DateTime.parse(json['date_end']),
      admins: List<String>.from(json['admins']),
      vesselId: json['vessel_id'],
      updatedAt: DateTime.parse(json['updated_at']),
      draftMeters: json['draft_meters'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onboarded_count': onboardedCount,
      'id': id,
      'date_start': dateStart.toIso8601String(),
      'date_end': dateEnd.toIso8601String(),
      'admins': admins,
      'vessel_id': vesselId,
      'updated_at': updatedAt.toIso8601String(),
      'draft_meters': draftMeters,
      'status': status,
    };
  }
}
