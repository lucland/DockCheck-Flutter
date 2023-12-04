import 'package:cripto_qr_googlemarine/models/event.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

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

  // Sync events from the server and update local database
  Future<void> syncEvents() async {
    try {
      // Fetch data from the server
      final serverEvents = await getAllEvents();

      // Update local database
      await updateLocalDatabase(serverEvents);
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> updateLocalDatabase(List<Event> serverEvents) async {
    // Clear local data
    await localStorageService.clearTable('events');

    // Insert new data into the local database
    for (var event in serverEvents) {
      await localStorageService.insertData('events', event.toJson());
    }
  }
}
