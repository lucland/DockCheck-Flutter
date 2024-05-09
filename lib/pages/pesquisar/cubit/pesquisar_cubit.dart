import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/repositories/employee_repository.dart';

import 'pesquisar_state.dart';

class PesquisarCubit extends Cubit<PesquisarState> {
  final EmployeeRepository employeeRepository;
  bool hasReachedMax = false;

  PesquisarCubit(this.employeeRepository) : super(PesquisarInitial());

  Future<void> fetchEmployees() async {
    try {
      emit(PesquisarLoading());
      final currentState = state;
      int currentPage = 1;
      if (currentState is PesquisarLoaded) {
        currentPage = currentState.currentPage;
      }
      List<Employee> employees =
          await employeeRepository.getAllEmployees(page: currentPage);
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      hasReachedMax =
          employees.isEmpty; // Assume empty result means no more data
      emit(PesquisarLoaded(
          employees, employeesOnboarded, hasReachedMax, currentPage++));
    } catch (e) {
      emit(PesquisarError("Failed to fetch employees: $e"));
    }
  }

  Future<void> fetchMoreEmployees() async {
    if (hasReachedMax) return;
    try {
      int currentPage = 1;
      if (state is PesquisarLoaded) {
        final currentState = state as PesquisarLoaded;
        currentPage = currentState.currentPage + 1;
      }
      List<Employee> moreEmployees =
          await employeeRepository.getAllEmployees(page: currentPage);
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      hasReachedMax = moreEmployees.isEmpty;
      final currentState = state;
      if (currentState is PesquisarLoaded) {
        emit(PesquisarLoaded(
            currentState.employees + moreEmployees,
            employeesOnboarded,
            hasReachedMax,
            moreEmployees.isNotEmpty ? currentPage : currentPage - 1));
      }
    } catch (e) {
      emit(PesquisarError("Failed to load more employees: $e"));
    }
  }

  //search employee by name or company
  Future<void> searchEmployees(String query) async {
    try {
      emit(PesquisarLoading());
      if (query.isEmpty) {
        emit(PesquisarInitial());
        return;
      }

      if (state is PesquisarLoaded) {
        final currentState = state as PesquisarLoaded;
        hasReachedMax = false;
      }
      List<Employee> employeesOnboarded =
          await employeeRepository.getEmployeesOnboarded();
      query = query.replaceAll(' ', '+');
      List<Employee> employees =
          await employeeRepository.searchEmployees(query);
      print(query);
      emit(PesquisarLoaded(employees, employeesOnboarded, hasReachedMax, 1));
    } catch (e) {
      emit(PesquisarError("Failed to search employees: $e"));
    }
  }
}
