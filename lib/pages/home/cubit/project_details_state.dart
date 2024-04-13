import 'package:dockcheck/models/employee.dart';

import '../../../models/project.dart';

class ProjectDetailsState {
  final Project project;
  final List<Employee> employees;
  final List<Employee> employeesUnvited;
  final bool isLoading;
  final bool isLoadingUninvited;
  final String errorMessage;
  final String errorMessageUninvited;

  ProjectDetailsState({
    required this.project,
    this.employees = const [],
    this.employeesUnvited = const [],
    this.isLoading = false,
    this.isLoadingUninvited = true,
    this.errorMessage = '',
    this.errorMessageUninvited = '',
  });

  ProjectDetailsState copyWith({
    Project? project,
    List<Employee>? employees,
    List<Employee>? employeesUnvited,
    bool? isLoading,
    bool? isLoadingUninvited,
    String? errorMessage,
    String? errorMessageUninvited,
  }) {
    return ProjectDetailsState(
      project: project ?? this.project,
      employees: employees ?? this.employees,
      employeesUnvited: employeesUnvited ?? this.employeesUnvited,
      isLoading: isLoading ?? this.isLoading,
      isLoadingUninvited: isLoadingUninvited ?? this.isLoadingUninvited,
      errorMessage: errorMessage ?? this.errorMessage,
      errorMessageUninvited:
          errorMessageUninvited ?? this.errorMessageUninvited,
    );
  }
}
