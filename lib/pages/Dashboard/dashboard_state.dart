import 'package:dockcheck/models/event.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Event> eventos;
  final String base64;
  DashboardLoaded(this.eventos, this.base64);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
