import 'package:cripto_qr_googlemarine/models/event.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

import '../utils/simple_logger.dart';

class EventRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  EventRepository(this.apiService, this.localStorageService);

  Future<Event> createEvent(Event event) async {
    final data = await apiService.post('events/create', event.toJson());
    return Event.fromJson(data);
  }

  Future<Event> getEvent(String id) async {
    final data = await apiService.get('events/$id');
    return Event.fromJson(data);
  }

  Future<Event> updateEvent(String id, Event event) async {
    final data = await apiService.put('events/$id', event.toJson());
    return Event.fromJson(data);
  }

  Future<void> deleteEvent(String id) async {
    await apiService.delete('events/$id');
  }

  Future<List<Event>> getAllEvents({int limit = 10, int offset = 0}) async {
    final data = await apiService.get('events?limit=$limit&offset=$offset');
    return (data as List).map((item) => Event.fromJson(item)).toList();
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    final data = await apiService.get('events/user/$userId');
    return (data as List).map((item) => Event.fromJson(item)).toList();
  }

  Future<void> syncEvents() async {
    try {
      final localIds = await localStorageService.getIds('events');
      final serverIds = await getEventsIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewEvents(newIds).then(
            (value) => SimpleLogger.fine('Events synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Events synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Events synchronization failed');
    }
  }

// Implement fetchAndStoreNewEvents similarly

  Future<void> updateLocalDatabase(List<Event> serverEvents) async {
    // Clear local data
    await localStorageService.clearTable('events');

    // Insert new data into the local database
    for (var event in serverEvents) {
      await localStorageService.insertData('events', event.toJson());
    }
  }

  //getEventsIdsFromServer returns a list of event ids
  Future<List<String>> getEventsIdsFromServer() async {
    final data = await apiService.get('events/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> fetchAndStoreNewEvents(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('events/$id');
      final auth = Event.fromJson(authData);
      await localStorageService.insertData('events', auth.toJson());
    }
  }
}
