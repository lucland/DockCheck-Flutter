import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/evento.dart';
import '../../../repositories/user_repository.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final UserRepository userRepository;

  DetailsCubit(this.userRepository) : super(DetailsInitial());

  fetchEvents(String identidade) async {
    try {
      emit(DetailsLoading());
      var eventos = await userRepository.fetchEvents(identidade);
      List<Evento> eventosMapped =
          eventos.map((eventoMap) => Evento.fromMap(eventoMap)).toList();
      print("Events fetched: ${eventos[0]}");
      emit(DetailsLoaded(eventosMapped));
    } catch (e) {
      print(e.toString());
      emit(DetailsError("Failed to fetch events."));
    }
  }
}
