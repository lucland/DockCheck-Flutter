import 'package:dockcheck/models/event.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final List<Event> eventos;
  DetailsLoaded(this.eventos);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
