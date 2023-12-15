import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/models/beacon.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class BeaconRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  BeaconRepository(this.apiService, this.localStorageService);

  Future<Beacon> createBeacon(Beacon beacon) async {
    // Save to local storage first
    await localStorageService.insertOrUpdate('beacons', beacon.toJson(), 'id');

    try {
      // Try posting to API
      final data = await apiService.post('beacons/create', beacon.toJson());
      SimpleLogger.info('Beacon created: $data');
      // Update local storage with API response
      await localStorageService.insertOrUpdate(
          'beacons', Beacon.fromJson(data).toJson(), 'id');
      return Beacon.fromJson(data);
    } catch (e) {
      // Log and handle API failure
      SimpleLogger.severe('Beacon creation failed: ${e.toString()}');
      return beacon; // Return the local version
    }
  }

  Future<Beacon> updateBeacon(String id, Beacon beacon) async {
    try {
      final data = await apiService.put('beacons/$id', beacon.toJson());
      SimpleLogger.info('Beacon updated: $data');
      // Update local storage with API response
      await localStorageService.insertOrUpdate(
          'beacons', Beacon.fromJson(data).toJson(), 'id');
      return Beacon.fromJson(data);
    } catch (e) {
      SimpleLogger.severe(
          'Failed to update beacon via API, updating local storage: ${e.toString()}');
      // Mark the beacon as pending update in local storage
      beacon.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'beacons', beacon.toJson(), 'id');
      return beacon; // Return the local version
    }
  }

  Future<void> deleteBeacon(String id) async {
    SimpleLogger.info('Beacon deleted: $id');
    await apiService.delete('beacons/$id');
  }

  Future<Beacon> getBeacon(String id) async {
    try {
      final data = await apiService.get('beacons/$id');
      return Beacon.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get beacon: ${e.toString()}');
      final localData = await localStorageService.getDataById('beacons', id);
      return Beacon.fromJson(localData);
    }
  }

  Future<List<Beacon>> getAllBeacons() async {
    try {
      final data = await apiService.get('beacons');
      return (data as List).map((item) => Beacon.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get all beacons: ${e.toString()}');
      // Fetch from local storage as fallback
      // Implement logic to return data from local storage or an empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<void> syncBeacons() async {
    SimpleLogger.info('Syncing beacons');

    // Try to fetch new data from the server and update local storage
    try {
      var serverBeacons = await apiService.get('beacons');
      await updateLocalDatabase(serverBeacons);
    } catch (e) {
      SimpleLogger.warning('Error fetching beacons from server: $e');
      // If fetching from server fails, use local data
    }

    // Sync any pending updates from local storage to the server
    var pendingBeacons =
        await localStorageService.getPendingData('beacons', 'status');
    for (var pending in pendingBeacons) {
      try {
        var response = await apiService.post('beacons/create', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('beacons', pending, 'id');
          SimpleLogger.info('Beacon synchronized');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending beacon: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (existing methods) ...

  // Add a method to update local storage with new data from the server
  Future<void> updateLocalDatabase(List<Beacon> serverBeacons) async {
    for (var beacon in serverBeacons) {
      var localData =
          await localStorageService.getDataById('beacons', beacon.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('beacons', beacon.toJson());
      } else {
        await localStorageService.updateData('beacons', beacon.toJson(), 'id');
      }
    }
  }
}
