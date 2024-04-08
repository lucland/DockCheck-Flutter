import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/repositories/picture_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
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
  final PictureRepository pictureRepository;
  @override
  bool isClosed = false;

  DetailsCubit(
    this.userRepository,
    this.eventRepository,
    this.localStorageService,
    this.authorizationRepository,
    this.vesselRepository,
    this.pictureRepository,
  ) : super(DetailsInitial());

  fetchEvents(String userId, String pictureId) async {
    try {
      if (!isClosed) {
        emit(DetailsLoading());
      }
      //    var picture = await pictureRepository.getPicture(userId);
      var eventos = await eventRepository.getEventsByUser(userId);
      SimpleLogger.info(eventos);
      List<Event> eventosMapped = eventos;
      print(eventosMapped.length > 0 ? eventosMapped[0].timestamp : "0");
      if (!isClosed) {
        emit(DetailsLoaded(
          eventosMapped,
          "",
        ));
      }
    } catch (e) {
      SimpleLogger.warning('Error during details_cubit fetchEvents: $e');
      if (!isClosed) {
        emit(DetailsError("Failed to fetch events."));
      }
    }
  }

  createCheckoutEvento(
      String userId, String justification, String pictureId) async {
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

      var vessel =
          await vesselRepository.getVessel(authorizations[0].employeeId);

      String UUID = DateTime.now().millisecondsSinceEpoch.toString();
      Event event = Event(
        id: UUID,
        timestamp: DateTime.now(),
        //TODO: alterar vesselId
        action: 1,
        status: '',
        beaconId: '', employeeId: '', projectId: '', sensorId: '',
      );

      await eventRepository.createEvent(event);

      fetchEvents(userId, userId);
      if (!isClosed) {
        emit(DetailsLoaded([], ''));
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
