import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';
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
  @override
  bool isClosed = false;

  DetailsCubit(
      this.userRepository,
      this.eventRepository,
      this.localStorageService,
      this.authorizationRepository,
      this.vesselRepository)
      : super(DetailsInitial());

  fetchEvents(String userId) async {
    try {
      if (!isClosed) {
        emit(DetailsLoading());
      }
      var eventos = await eventRepository.getEventsByUser(userId);
      List<Event> eventosMapped = eventos;
      if (!isClosed) {
        emit(DetailsLoaded(eventosMapped));
      }
    } catch (e) {
      SimpleLogger.warning('Error during details_cubit fetchEvents: $e');
      if (!isClosed) {
        emit(DetailsError("Failed to fetch events."));
      }
    }
  }

  createCheckoutEvento(String userId, String justification) async {
    try {
      if (!isClosed) {
        emit(DetailsLoading());
      }

      var user = await localStorageService.getUser();
      if (user == null) {
        SimpleLogger.warning('No logged-in user found.');
        if (!isClosed) {
          emit(DetailsError("No logged-in user found."));
        }
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
        vesselId: vessel.id,
        action: 1,
        justification: justification,
        status: '',
        beaconId: '',
      );

      await eventRepository.createEvent(event);

      fetchEvents(userId);
      if (!isClosed) {
        emit(DetailsLoaded([]));
      }
    } catch (e) {
      SimpleLogger.warning(
          'Error during details_cubit createCheckoutEvento: $e');
      if (!isClosed) {
        emit(DetailsError("Failed to create event."));
      }
    }
  }

  @override
  Future<void> close() async {
    if (!isClosed) {
      isClosed = true;

      // Dispose of any resources, cancel subscriptions, etc.
      // For example, if you have streams, make sure to close them.

      // Let the superclass handle the rest of the closing process.
      await super.close();
    }
  }
}
