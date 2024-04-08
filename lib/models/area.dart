class Area {
  String id;
  int count;
  String name;
  bool isPortalo;
  String status;

  Area({
    required this.id,
    required this.count,
    required this.name,
    required this.isPortalo,
    required this.status,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      count: json['count'],
      name: json['name'],
      isPortalo: json['is_portalo'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
      'name': name,
      'is_portalo': isPortalo,
      'status': status,
    };
  }

  Area copyWith({
    String? id,
    int? count,
    String? name,
    bool? isPortalo,
    String? status,
  }) {
    return Area(
      id: id ?? this.id,
      count: count ?? this.count,
      name: name ?? this.name,
      isPortalo: isPortalo ?? this.isPortalo,
      status: status ?? this.status,
    );
  }
}
