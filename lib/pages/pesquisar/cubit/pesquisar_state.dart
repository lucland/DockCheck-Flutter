import 'package:dockcheck/models/employee.dart';

abstract class PesquisarState {}

class PesquisarInitial extends PesquisarState {}

class PesquisarLoading extends PesquisarState {}

class PesquisarLoaded extends PesquisarState {
  final List<Employee> employees;
  final bool isAdmin;
  PesquisarLoaded(this.employees, this.isAdmin);
}

//add state for employee loaded
class EmployeeLoaded extends PesquisarState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}

class PesquisarError extends PesquisarState {
  final String message;
  PesquisarError(this.message);
}
