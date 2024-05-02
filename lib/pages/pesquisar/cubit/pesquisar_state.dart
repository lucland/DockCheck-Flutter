import 'package:dockcheck/models/employee.dart';

abstract class PesquisarState {}

class PesquisarInitial extends PesquisarState {}

class PesquisarLoading extends PesquisarState {}

class PesquisarLoaded extends PesquisarState {
  final List<Employee> employees;
  final List<Employee> employeesOnboarded;
  final bool hasReachedMax;
  PesquisarLoaded(this.employees, this.employeesOnboarded, this.hasReachedMax);
}

class PesquisarError extends PesquisarState {
  final String message;
  PesquisarError(this.message);
}
