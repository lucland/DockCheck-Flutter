import 'package:dockcheck/models/beacon.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';

class BeaconRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  BeaconRepository(this.apiService, this.localStorageService);

  Future<Beacon> createBeacon(Beacon beacon) async {
    try {
      final data = await apiService.post('beacons/create', beacon.toJson());
      SimpleLogger.info('Beacon created: $data');
      return Beacon.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Beacon creation failed: ${e.toString()}');
      return beacon;
    }
  }

  Future<Beacon> updateBeacon(String id, Beacon beacon) async {
    try {
      final data = await apiService.put('beacons/$id', beacon.toJson());
      SimpleLogger.info('Beacon updated: $data');
      return Beacon.fromJson(data);
    } catch (e) {
      SimpleLogger.severe(
          'Failed to update beacon via API, updating local storage: ${e.toString()}');
      beacon.status = 'pending_update';
      return beacon;
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
      return [];
    }
  }

  Future<void> syncBeacons() async {
    SimpleLogger.info('Syncing beacons');

    try {
      var serverBeacons = await apiService.get('beacons');
      await updateLocalDatabase(serverBeacons);
    } catch (e) {
      SimpleLogger.warning('Error fetching beacons from server: $e');
    }

    var pendingBeacons =
        await localStorageService.getPendingData('beacons', 'status');
    for (var pending in pendingBeacons) {
      try {
        var response = await apiService.post('beacons/create', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          SimpleLogger.info('Beacon synchronized');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending beacon: $e');
      }
    }
  }

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
