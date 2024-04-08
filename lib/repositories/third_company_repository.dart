import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ThirdCompany {
  final int id;
  final String name;
  final String logo;
  final String razaoSocial;
  final String cnpj;
  final int admisId;
  final String address;
  final bool isVesselCompany;
  final String telephone;
  final String email;
  final String status;

  ThirdCompany({
    required this.id,
    required this.name,
    required this.logo,
    required this.razaoSocial,
    required this.cnpj,
    required this.admisId,
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
      admisId: json['admis_id'],
      address: json['address'],
      isVesselCompany: json['is_vessel_company'],
      telephone: json['telephone'],
      email: json['email'],
      status: json['status'],
    );
  }
}

class ThirdCompanyPage extends StatefulWidget {
  final ApiService apiService;

  ThirdCompanyPage({required this.apiService});

  @override
  _ThirdCompanyPageState createState() => _ThirdCompanyPageState();
}

class _ThirdCompanyPageState extends State<ThirdCompanyPage> {
  late Future<List<ThirdCompany>> _thirdCompanies;

  @override
  void initState() {
    super.initState();
    _thirdCompanies = _fetchThirdCompanies();
  }

  Future<List<ThirdCompany>> _fetchThirdCompanies() async {
    final response = await widget.apiService.get('thirdCompanies');
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => ThirdCompany.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load third companies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Companies'),
      ),
      body: FutureBuilder<List<ThirdCompany>>(
        future: _thirdCompanies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].email),
                );
              },
            );
          }
        },
      ),
    );
  }
}
