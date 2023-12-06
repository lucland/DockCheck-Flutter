import 'package:cripto_qr_googlemarine/models/event.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';
import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/authorization_repository.dart';
import '../../../repositories/event_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../repositories/vessel_repository.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final UserRepository userRepository;
  final EventRepository eventRepository;
  final AuthorizationRepository authorizationRepository;
  final VesselRepository vesselRepository;
  final LocalStorageService localStorageService;

  DetailsCubit(
      this.userRepository,
      this.eventRepository,
      this.localStorageService,
      this.authorizationRepository,
      this.vesselRepository)
      : super(DetailsInitial());

  fetchEvents(String userId) async {
    try {
      emit(DetailsLoading());
      var eventos = await eventRepository.getEventsByUser(userId);
      List<Event> eventosMapped = eventos;
      emit(DetailsLoaded(eventosMapped));
    } catch (e) {
      SimpleLogger.warning('Error during details_cubit fetchEvents: $e');
      emit(DetailsError("Failed to fetch events."));
    }
  }

  createCheckoutEvento(String userId, String justification) async {
    try {
      emit(DetailsLoading());

      var user = await localStorageService.getUser();
      if (user == null) {
        SimpleLogger.warning('No logged-in user found.');
        emit(DetailsError("No logged-in user found."));
        return;
      }

      var authorizations =
          await authorizationRepository.getAuthorizations(user.id);

      var vessel = await vesselRepository.getVessel(authorizations[0].vesselId);

      String UUID = DateTime.now().millisecondsSinceEpoch.toString();
      Event event = Event(
          id: UUID,
          portalId: '0',
          userId: userId,
          timestamp: DateTime.now(),
          direction: 1,
          vesselId: vessel.id,
          picture: '',
          action: 1,
          manual: true,
          justification: justification,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

      await eventRepository.createEvent(event);

      fetchEvents(userId);
      emit(DetailsLoaded([]));
    } catch (e) {
      SimpleLogger.warning(
          'Error during details_cubit createCheckoutEvento: $e');
      emit(DetailsError("Failed to create event."));
    }
  }
}
