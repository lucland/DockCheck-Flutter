class ThirdCompany {
  String id;
  String name;
  String logo;
  String razaoSocial;
  String cnpj;
  String address;
  bool isVesselCompany;
  String telephone;
  String email;
  String status;

  ThirdCompany({
    required this.id,
    required this.name,
    required this.logo,
    required this.razaoSocial,
    required this.cnpj,
    required this.address,
    required this.isVesselCompany,
    required this.telephone,
    required this.email,
    required this.status,
  });

  factory ThirdCompany.fromJson(Map<String, dynamic> json) {
    return ThirdCompany(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      razaoSocial: json['razao_social'],
      cnpj: json['cnpj'],
      address: json['address'],
      isVesselCompany: json['is_vessel_company'],
      telephone: json['telephone'],
      email: json['email'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'razao_social': razaoSocial,
      'cnpj': cnpj,
      'address': address,
      'is_vessel_company': isVesselCompany,
      'telephone': telephone,
      'email': email,
      'status': status,
    };
  }

  ThirdCompany copyWith({
    String? id,
    String? name,
    String? logo,
    String? razaoSocial,
    String? cnpj,
    String? address,
    bool? isVesselCompany,
    String? telephone,
    String? email,
    String? status,
  }) {
    return ThirdCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      cnpj: cnpj ?? this.cnpj,
      address: address ?? this.address,
      isVesselCompany: isVesselCompany ?? this.isVesselCompany,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
