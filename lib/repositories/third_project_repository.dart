import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ThirdProject {
  final int id;
  final String name;
  final int onboardedCount;
  final String dateStart;
  final String dateEnd;
  final String thirdCompany;
  final int projectId;
  final List<int> allowedAreasId;
  final List<int> employeesId;
  final String status;

  ThirdProject({
    required this.id,
    required this.name,
    required this.onboardedCount,
    required this.dateStart,
    required this.dateEnd,
    required this.thirdCompany,
    required this.projectId,
    required this.allowedAreasId,
    required this.employeesId,
    required this.status,
  });

  factory ThirdProject.fromJson(Map<String, dynamic> json) {
    return ThirdProject(
      id: json['id'],
      name: json['name'],
      onboardedCount: json['onboarded_count'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      thirdCompany: json['third_company'],
      projectId: json['project_id'],
      allowedAreasId: List<int>.from(json['allowed_areas_id']),
      employeesId: List<int>.from(json['employees_id']),
      status: json['status'],
    );
  }
}

class ThirdProjectPage extends StatefulWidget {
  final ApiService apiService;

  ThirdProjectPage({required this.apiService});

  @override
  _ThirdProjectPageState createState() => _ThirdProjectPageState();
}

class _ThirdProjectPageState extends State<ThirdProjectPage> {
  late Future<List<ThirdProject>> _thirdProjects;

  @override
  void initState() {
    super.initState();
    _thirdProjects = _fetchThirdProjects();
  }

  Future<List<ThirdProject>> _fetchThirdProjects() async {
    final response = await widget.apiService.get('thirdProjects');
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data;
      return responseData.map((json) => ThirdProject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load third projects');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Projects'),
      ),
      body: FutureBuilder<List<ThirdProject>>(
        future: _thirdProjects,
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
                  subtitle: Text(snapshot.data![index].status),
                );
              },
            );
          }
        },
      ),
    );
  }
}
