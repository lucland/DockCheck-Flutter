import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/evento.dart';
import '../../../repositories/user_repository.dart';
import '../../../utils/ui/strings.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final UserRepository userRepository;

  DetailsCubit(this.userRepository) : super(DetailsInitial());

  fetchEvents(String identidade) async {
    try {
      emit(DetailsLoading());
      var eventos = await userRepository.fetchEvents(identidade);
      List<Evento> eventosMapped = eventos
          .map((eventoMap) => Evento.fromMap(eventoMap))
          .toList()
          .reversed
          .toList();
      print("Events fetched: ${eventos[0]}");
      emit(DetailsLoaded(eventosMapped));
    } catch (e) {
      print(e.toString());
      emit(DetailsError("Failed to fetch events."));
    }
  }

  createCheckoutEvento(String identidade, String vessel) async {
    try {
      emit(DetailsLoading());
      Evento evento = Evento(
        acao: CQStrings.checkOut,
        user: identidade,
        vessel: vessel,
        createdAt: Timestamp.fromDate(DateTime.now()),
      );
      await userRepository.addEvent(evento.toMap());
      fetchEvents(identidade);
    } catch (e) {
      print(e.toString());
      emit(DetailsError("Failed to create event."));
    }
  }
}
