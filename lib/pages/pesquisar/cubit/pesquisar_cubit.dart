import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/repositories/employee_repository.dart';

import 'pesquisar_state.dart';

class PesquisarCubit extends Cubit<PesquisarState> {
  final EmployeeRepository employeeRepository;
  int currentPage = 1;
  bool hasReachedMax = false;

  PesquisarCubit(this.employeeRepository) : super(PesquisarInitial());

  Future<void> fetchEmployees() async {
    try {
      emit(PesquisarLoading());
      List<Employee> employees =
          await employeeRepository.getAllEmployees(page: currentPage);
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      currentPage++;
      hasReachedMax =
          employees.isEmpty; // Assume empty result means no more data
      emit(PesquisarLoaded(employees, employeesOnboarded, hasReachedMax));
    } catch (e) {
      emit(PesquisarError("Failed to fetch employees: $e"));
    }
  }

  Future<void> fetchMoreEmployees() async {
    if (hasReachedMax) return;
    try {
      List<Employee> moreEmployees =
          await employeeRepository.getAllEmployees(page: currentPage);
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      currentPage++;
      hasReachedMax = moreEmployees.isEmpty;
      final currentState = state;
      if (currentState is PesquisarLoaded) {
        emit(PesquisarLoaded(currentState.employees + moreEmployees,
            employeesOnboarded, hasReachedMax));
      }
    } catch (e) {
      emit(PesquisarError("Failed to load more employees: $e"));
    }
  }

  //search employee by name or company
  Future<void> searchEmployees(String query) async {
    try {
      emit(PesquisarLoading());
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      List<Employee> employees =
          await employeeRepository.searchEmployees(query);
      emit(PesquisarLoaded(employees, employeesOnboarded, hasReachedMax));
    } catch (e) {
      emit(PesquisarError("Failed to search employees: $e"));
    }
  }
}
