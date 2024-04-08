class Sensor {
  String id;
  List<String> beaconsFound;
  String areaId;
  int code;
  String status;
  bool inVessel;
  int locationX;
  int locationY;

  Sensor({
    required this.id,
    required this.beaconsFound,
    required this.areaId,
    required this.code,
    required this.status,
    required this.inVessel,
    required this.locationX,
    required this.locationY,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      beaconsFound: List<String>.from(json['beacons_found']),
      areaId: json['area_id'],
      code: json['code'],
      status: json['status'],
      inVessel: json['in_vessel'],
      locationX: json['location_x'],
      locationY: json['location_y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beacons_found': beaconsFound,
      'area_id': areaId,
      'code': code,
      'status': status,
      'in_vessel': inVessel,
      'location_x': locationX,
      'location_y': locationY,
    };
  }

  Sensor copyWith({
    String? id,
    List<String>? beaconsFound,
    String? areaId,
    int? code,
    String? status,
    bool? inVessel,
    int? locationX,
    int? locationY,
  }) {
    return Sensor(
      id: id ?? this.id,
      beaconsFound: beaconsFound ?? this.beaconsFound,
      areaId: areaId ?? this.areaId,
      code: code ?? this.code,
      status: status ?? this.status,
      inVessel: inVessel ?? this.inVessel,
      locationX: locationX ?? this.locationX,
      locationY: locationY ?? this.locationY,
    );
  }
}
