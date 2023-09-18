import 'package:cripto_qr_googlemarine/models/evento.dart';

abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final List<Evento> eventos;
  DetailsLoaded(this.eventos);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}
