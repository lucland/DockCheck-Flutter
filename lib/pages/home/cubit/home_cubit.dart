import 'dart:convert';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/pages/home/cubit/home_state.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../models/document.dart';
import '../../../models/project.dart';
import '../../../repositories/project_repository.dart';
import '../../../services/local_storage_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProjectRepository projectRepository;
  final EmployeeRepository employeeRepository;
  final LocalStorageService localStorageService;

  HomeCubit(
    this.projectRepository,
    this.employeeRepository,
    this.localStorageService,
  ) : super(HomeState());
  //retrieve the logged in userId from the local storage.getUserId Future method and set it into a variable
  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  //fetch all projects from the repository and emit the state with the projects
  void fetchProjects() async {
    getLoggedUserId();
    print('fetchProjects');
    emit(state.copyWith(
      isLoading: true,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      projects: [],
    ));
    try {
      String? userId = await localStorageService.getUserId();
      final projects = await projectRepository.getAllProjectsByUserId(userId!);
      //reorder the projects to show the most recent first
      projects.sort((a, b) => b.dateStart.compareTo(a.dateStart));
      emit(state.copyWith(isLoading: false, projects: projects));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }

    loadMoreData();
  }

  void fetchEmployees() async {
    emit(state.copyWith(isLoading: true, employees: []));
    try {
      final employees = await employeeRepository.getAllEmployees();
      final employeesFound = employees
          .where((employee) =>
              employee.lastAreaFound != null &&
              employee.lastAreaFound!.isNotEmpty)
          .toList();
      emit(state.copyWith(isLoading: false, employees: employeesFound));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void updateName(String name) => emit(state.copyWith(name: name));

  void updateStartDate(DateTime startDate) =>
      emit(state.copyWith(startDate: startDate));

  void updateEndDate(DateTime endDate) =>
      emit(state.copyWith(endDate: endDate));

  void updateVesselId(String vesselId) =>
      emit(state.copyWith(vesselId: vesselId));

  void updateCompanyId(String companyId) =>
      emit(state.copyWith(companyId: companyId));

  void addFile(String fileName) {
    final updatedFileNames = List<String>.from(state.fileNames)..add(fileName);
    emit(state.copyWith(fileNames: updatedFileNames));
  }

  //turn the File to base64, create a Document object and add to the state
  void addDocument(PlatformFile file) async {
    //turn file to base64
    getLoggedUserId();

    try {} catch (e) {
      print(e.toString());

      if (!isClosed) {
        emit(state.copyWith(
          errorMessage: e.toString(),
        ));
      }
    }

    final String base64 = base64Encode(file.bytes!);

    final updatedDocuments = List<Document>.from(state.documents)
      ..add(Document(
        id: const Uuid().v4(),
        type: file.extension ?? 'unknown',
        employeeId: loggedUserId,
        expirationDate: DateTime.now().add(const Duration(days: 365)),
        path: base64,
        status: 'pending',
      ));
    emit(state.copyWith(documents: updatedDocuments));
  }

  void removeFile(String fileName) {
    final updatedFileNames = List<String>.from(state.fileNames)
      ..remove(fileName);
    emit(state.copyWith(fileNames: updatedFileNames));
  }

  //updateIsDocking
  void updateIsDocking(bool isDocking) =>
      emit(state.copyWith(isDocking: isDocking));

  //update the address
  void updateAddress(String address) => emit(state.copyWith(address: address));

  //load more data function
  Future<void> loadMoreData() async {
    print('loadMoreData');
    if (state.isFetching) return;
    emit(state.copyWith(isFetching: true));
    List<Employee> newEmployees =
        await employeeRepository.getEmployeesOnboarded(page: state.currentPage);
    emit(state.copyWith(
      employees: [...state.employees, ...newEmployees],
      isFetching: false,
      currentPage:
          newEmployees.isNotEmpty ? state.currentPage + 1 : state.currentPage,
    ));
  }

  // Implement other update methods following the pattern above

  void createProject(String name, String vesselId, String address) async {
    emit(state.copyWith(
        isLoading: true,
        name: name,
        vesselId: vesselId,
        address: address,
        thirdCompaniesId: []));

    try {
      final project = Project(
        id: const Uuid().v4(), // Generate a new UUID for the project
        name: state.isDocking
            ? 'Docagem - ${state.vesselId}'
            : 'Mobilização - ${state.vesselId}',
        dateStart: state.startDate ?? DateTime.now(),
        dateEnd: state.endDate ?? DateTime.now(),
        vesselId: state.vesselId,
        companyId: "companyId",
        thirdCompaniesId: state.thirdCompaniesId,
        adminsId: [loggedUserId],
        employeesId: [],
        areasId: ["areasId"],
        address: state.address,
        isDocking: state.isDocking,
        status: 'created',
        userId: loggedUserId,
      );
      await projectRepository.createProject(project);
      emit(state.copyWith(isLoading: false, projectCreated: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  //reset function
  void reset() {
    emit(HomeState());
    print('reset');
    fetchProjects();
  }
}
