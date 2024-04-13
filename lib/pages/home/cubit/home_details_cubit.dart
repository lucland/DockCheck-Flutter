import 'dart:convert';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/pages/home/cubit/project_details_state.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/document.dart';
import '../../../models/project.dart';
import '../../../repositories/project_repository.dart';
import '../../../services/local_storage_service.dart';

class HomeDetailsCubit extends Cubit<ProjectDetailsState> {
  final EmployeeRepository employeeRepository;
  final ProjectRepository projectRepository;
  final LocalStorageService localStorageService;

  HomeDetailsCubit(this.employeeRepository, this.projectRepository,
      this.localStorageService)
      : super(ProjectDetailsState(
          project: Project(
            id: '',
            name: '',
            dateStart: DateTime.now(),
            dateEnd: DateTime.now(),
            vesselId: '',
            companyId: '',
            thirdCompaniesId: [],
            adminsId: [],
            employeesId: [],
            areasId: [],
            address: '',
            isDocking: false,
            status: '',
            userId: '',
          ),
        ));
  //retrieve the logged in userId from the local storage.getUserId Future method and set it into a variable
  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  //fetch project by id from the repository and emit the state with the project
  void fetchProjectById(String projectId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final project = await projectRepository.getProjectById(projectId);
      emit(state.copyWith(project: project, isLoading: false));
      fetchEmployees();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //fetch all projects from the repository and emit the state with the projects
  void fetchEmployees() async {
    emit(state.copyWith(isLoading: true, employees: []));
    try {
      //getEmployeeById for each state.project.employeesId and set the employees in the state.employees
      List<String> ids = state.project.employeesId;
      List<Employee> employees = [];
      for (var id in ids) {
        final employee = await employeeRepository.getEmployeeById(id);
        employees.add(employee);
      }
      emit(state.copyWith(employees: employees, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //fetch all employees from repository, subtract the employees already in the project and emit the state with the employees in the state.employeesUnvited
  void fetchEmployeesUninvited() async {
    emit(state.copyWith(isLoadingUninvited: true));
    try {
      final employees = await employeeRepository.getAllEmployees();
      final employeesUninvited = employees
          .where((element) =>
              !state.project.employeesId.contains(element.id) &&
              element.id != loggedUserId)
          .toList();
      emit(state.copyWith(
          employeesUnvited: employeesUninvited, isLoadingUninvited: false));
    } catch (e) {
      emit(state.copyWith(
          isLoadingUninvited: false, errorMessage: e.toString()));
    }
  }



  void setProject(Project project) {
    emit(state.copyWith(project: project));
  }


  //reset function
  void reset() {
    emit(ProjectDetailsState(
      project: Project(
        id: '',
        name: '',
        dateStart: DateTime.now(),
        dateEnd: DateTime.now(),
        vesselId: '',
        companyId: '',
        thirdCompaniesId: [],
        adminsId: [],
        employeesId: [],
        areasId: [],
        address: '',
        isDocking: false,
        status: '',
        userId: '',
      ),
      employees: [],
      employeesUnvited: [],
    ));
  }
}
