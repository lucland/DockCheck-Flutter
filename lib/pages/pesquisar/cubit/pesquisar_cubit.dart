
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_state.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:dockcheck/repositories/project_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/simple_logger.dart';

class PesquisarCubit extends Cubit<PesquisarState> {
  final EmployeeRepository employeeRepository;
  final ProjectRepository projectRepository;
  final LocalStorageService localStorageService;
  List<Employee> allEmployee = [];
  List<Employee> filteredEmployee = [];
  bool isSearching = false;
  String searchQuery = '';

  @override
  bool isClosed = false;

  PesquisarCubit(
      this.employeeRepository, this.projectRepository, this.localStorageService)
      : super(PesquisarInitial());

  Future<String?> get loggedInUser => localStorageService.getUserId();
  String loggedUserId = '';

  //assign the logged in userId to the variable, knowing that it is a Future<String>
  void getLoggedUserId() async {
    loggedUserId = await loggedInUser ?? '';
  }

  //get signed in user number

  Future<void> fetchEmployees() async {
    getLoggedUserId();

    print("fetchEmployees");
    print(loggedUserId);
    SimpleLogger.info('Fetching employees');
    try {
      if (!isClosed) {
        emit(PesquisarLoading());
      }

      String? userId = await localStorageService.getUserId();
      print(userId);
      User? logged = await localStorageService.getUser();

      allEmployee = await employeeRepository.getAllEmployees();
      print(allEmployee.length);
      bool isAd = true;
      if (logged != null && logged.number == 0) {
        isAd = false;
      }
      if (!isClosed) {
        emit(PesquisarLoaded(allEmployee, isAd));
      }
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      if (!isClosed) {
        emit(PesquisarError("Failed to fetch users1. $e"));
      }
    }
  }

  Future<void> searchEmployee(String query) async {
    try {
      if (!isClosed) {
        emit(PesquisarLoading());
      }

      searchQuery = query;
      isSearching = true;

      // Verifica se já carregou os usuários do banco de dados
      if (allEmployee.isEmpty) {
        String? userId = await localStorageService.getUserId();

        allEmployee = await employeeRepository.getEmployeesByUserId(userId!);
      }

      filteredEmployee = allEmployee
          .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      String? userId = await localStorageService.getUserId();
      print(userId);
      User? logged = await localStorageService.getUser();
      bool isAd = true;
      if (logged != null && logged.number == 0) {
        isAd = false;
      }

      if (!isClosed) {
        emit(PesquisarLoaded(filteredEmployee, isAd));
      }
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      if (!isClosed) {
        emit(PesquisarError("Failed to fetch users2. $e"));
      }
    }
  }

  void _applySearchFilter() async {
    filteredEmployee = allEmployee
        .where((employee) =>
            employee.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    String? userId = await localStorageService.getUserId();
    print(userId);
    User? logged = await localStorageService.getUser();
    bool isAd = true;
    if (logged != null && logged.number == 0) {
      isAd = false;
    }

    emit(PesquisarLoaded(filteredEmployee, isAd));
  }

  @override
  Future<void> close() async {
    if (!isClosed) {
      isClosed = true;
      await super.close();
    }
  }
}
