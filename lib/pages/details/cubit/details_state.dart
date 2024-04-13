import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/event.dart';
import '../../../models/document.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Employee employee;
  final List<Document> documents;
  final List<String> urls = [];
  DetailsLoaded(this.employee, this.documents, {List<String>? urls});
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
