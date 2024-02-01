import 'package:dockcheck/models/event.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final List<Event> eventos;
  final String base64;
  DetailsLoaded(this.eventos, this.base64);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
