import 'package:dockcheck/models/document.dart';

import '../../../models/project.dart';

class ProjectState {
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final String vesselId;
  final String companyId;
  final List<String> thirdCompaniesId;
  final List<String> adminsId;
  final List<String> areasId;
  final bool isDocking;
  final String address;
  final String status;
  final bool isLoading;
  final bool projectCreated;
  final String errorMessage;
  final List<String> fileNames;
  final List<Document> documents;
  final List<Project> projects;

  ProjectState({
    this.name = '',
    this.startDate,
    this.endDate,
    this.vesselId = '',
    this.companyId = '',
    this.thirdCompaniesId = const [],
    this.adminsId = const [],
    this.areasId = const [],
    this.isDocking = false,
    this.address = '',
    this.status = '',
    this.isLoading = false,
    this.projectCreated = false,
    this.errorMessage = '',
    this.fileNames = const [],
    this.documents = const [],
    this.projects = const [],
  });

  ProjectState copyWith({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? vesselId,
    String? companyId,
    List<String>? thirdCompaniesId,
    List<String>? adminsId,
    List<String>? areasId,
    bool? isDocking,
    String? address,
    String? status,
    bool? isLoading,
    bool? projectCreated,
    String? errorMessage,
    List<String>? fileNames,
    List<Document>? documents,
    List<Project>? projects,
  }) {
    return ProjectState(
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      vesselId: vesselId ?? this.vesselId,
      companyId: companyId ?? this.companyId,
      thirdCompaniesId: thirdCompaniesId ?? this.thirdCompaniesId,
      adminsId: adminsId ?? this.adminsId,
      areasId: areasId ?? this.areasId,
      isDocking: isDocking ?? this.isDocking,
      address: address ?? this.address,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      projectCreated: projectCreated ?? this.projectCreated,
      errorMessage: errorMessage ?? this.errorMessage,
      fileNames: fileNames ?? this.fileNames,
      documents: documents ?? this.documents,
      projects: projects ?? this.projects,
    );
  }
}
