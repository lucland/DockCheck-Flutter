import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class EventRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  EventRepository(this.apiService, this.localStorageService);

  Future<Event> createEvent(Event event) async {
    //await localStorageService.insertOrUpdate('events', event.toJson(), 'id');

    try {
      final data = await apiService.post('events/create', event.toJson());
      // await localStorageService.insertOrUpdate(
      //    'events', Event.fromJson(data).toJson(), 'id');
      return Event.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create event: ${e.toString()}');
      return event;
    }
  }

  Future<Event> getEvent(String id) async {
    try {
      final data = await apiService.get('events/$id');
      return Event.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get event: ${e.toString()}');
      final localData = await localStorageService.getDataById('events', id);
      if (localData.isNotEmpty) {
        return Event.fromJson(localData);
      } else {
        throw Exception('Event not found locally');
      }
    }
  }

  Future<List<Event>> getAllEvents({int limit = 10, int offset = 0}) async {
    try {
      final data = await apiService.get('events?limit=$limit&offset=$offset');
      return (data as List).map((item) => Event.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get all events: ${e.toString()}');
      // Fetch from local storage as fallback
      // Implement logic to return data from local storage or an empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    try {
      final data = await apiService.put('events/$id', event.toJson());
      // await localStorageService.insertOrUpdate(
      //   'events', Event.fromJson(data).toJson(), 'id');
      return Event.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update event: ${e.toString()}');
      event.status = 'pending_update'; // Assuming 'status' field exists
      // await localStorageService.insertOrUpdate('events', event.toJson(), 'id');
      return event;
    }
  }

  Future<void> deleteEvent(String id) async {
    await apiService.delete('events/$id');
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    final data = await apiService.get('events/user/$userId');
    return (data as List).map((item) => Event.fromJson(item)).toList();
  }

  Future<void> syncEvents() async {
    SimpleLogger.info('Syncing events');

    try {
      var serverEventIds = await getEventsIdsFromServer();
      await fetchAndStoreNewEvents(serverEventIds);
    } catch (e) {
      SimpleLogger.warning('Error fetching events from server: $e');
      // If fetching from server fails, use local data
    }

    var pendingEvents =
        await localStorageService.getPendingData('events', 'status');
    for (var pending in pendingEvents) {
      try {
        var response = await apiService.post('events/create', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          //  await localStorageService.insertOrUpdate('events', pending, 'id');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending event: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (existing methods) ...

  // Add a method to update local storage with new data from the server
  Future<void> fetchAndStoreNewEvents(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final eventData = await apiService.get('events/$id');
        final event = Event.fromJson(eventData);
        // await localStorageService.insertOrUpdate(
        //     'events', event.toJson(), 'id');
      } catch (e) {
        SimpleLogger.warning('Failed to fetch event: $id, error: $e');
        // Continue with the next ID if one fetch fails
      }
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
}
