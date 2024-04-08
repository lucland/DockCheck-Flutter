class ProjectAdmin {
  String id;
  String projectId;
  String userId;

  ProjectAdmin({
    required this.id,
    required this.projectId,
    required this.userId,
  });

  factory ProjectAdmin.fromJson(Map<String, dynamic> json) {
    return ProjectAdmin(
      id: json['id'],
      projectId: json['project_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'user_id': userId,
    };
  }

  ProjectAdmin copyWith({
    String? id,
    String? projectId,
    String? userId,
  }) {
    return ProjectAdmin(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
    );
  }
}
