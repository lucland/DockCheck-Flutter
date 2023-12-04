import 'package:cripto_qr_googlemarine/models/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/event_repository.dart';
import '../../../repositories/user_repository.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;

  DetailsCubit(this.userRepository, this.eventRepository)
      : super(DetailsInitial());

  fetchEvents(String userId) async {
    try {
      emit(DetailsLoading());
      var eventos = await eventRepository.getEventsByUser(userId);
      List<Event> eventosMapped = eventos;
      print("Events fetched: ${eventos[0]}");
      emit(DetailsLoaded(eventosMapped));
    } catch (e) {
      print(e.toString());
      emit(DetailsError("Failed to fetch events."));
    }
  }

  createCheckoutEvento(String userId, String vesselId, String portalId) async {
    try {
      emit(DetailsLoading());
      //generate unique id
      String UUID = DateTime.now().millisecondsSinceEpoch.toString();
      Event event = Event(
          id: UUID,
          portalId: portalId,
          userId: userId,
          timestamp: DateTime.now(),
          direction: 1,
          vesselId: vesselId,
          picture: '',
          action: 1,
          manual: false,
          justification: '');

      await eventRepository.createEvent(event);
      fetchEvents(userId);
      emit(DetailsLoaded([]));
    } catch (e) {
      print(e.toString());
      emit(DetailsError("Failed to create event."));
    }
  }
}
