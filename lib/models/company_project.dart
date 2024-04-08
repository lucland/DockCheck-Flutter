class CompanyProject {
  String id;
  String companyId;
  String projectId;

  CompanyProject({
    required this.id,
    required this.companyId,
    required this.projectId,
  });

  factory CompanyProject.fromJson(Map<String, dynamic> json) {
    return CompanyProject(
      id: json['id'],
      companyId: json['company_id'],
      projectId: json['project_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'project_id': projectId,
    };
  }

  CompanyProject copyWith({
    String? id,
    String? companyId,
    String? projectId,
  }) {
    return CompanyProject(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      projectId: projectId ?? this.projectId,
    );
  }
}
