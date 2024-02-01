import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/models/docking.dart';

import '../utils/simple_logger.dart';

class DockingRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  DockingRepository(this.apiService, this.localStorageService);

  Future<Docking> createDocking(Docking docking) async {
    //  await localStorageService.insertOrUpdate(
    //    'dockings', docking.toJson(), 'id');

    try {
      final data = await apiService.post('dockings/create', docking.toJson());
      //   await localStorageService.insertOrUpdate(
      //    'dockings', Docking.fromJson(data).toJson(), 'id');
      return Docking.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create docking: ${e.toString()}');
      return docking;
    }
  }

  Future<Docking> getDocking(String id) async {
    try {
      final data = await apiService.get('dockings/$id');
      return Docking.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get docking: ${e.toString()}');
      final localData = await localStorageService.getDataById('dockings', id);
      if (localData.isNotEmpty) {
        return Docking.fromJson(localData);
      } else {
        throw Exception('Docking not found locally');
      }
    }
  }

  Future<List<Docking>> getAllDockings() async {
    try {
      final data = await apiService.get('dockings');
      return (data as List).map((item) => Docking.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get all dockings: ${e.toString()}');
      // Fetch from local storage as fallback
      // Implement logic to return data from local storage or an empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<Docking> updateDocking(String id, Docking docking) async {
    try {
      final data = await apiService.put('dockings/$id', docking.toJson());
      // await localStorageService.insertOrUpdate(
      //   'dockings', Docking.fromJson(data).toJson(), 'id');
      return Docking.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update docking: ${e.toString()}');
      docking.status = 'pending_update'; // Assuming 'status' field exists
      // await localStorageService.insertOrUpdate(
      //    'dockings', docking.toJson(), 'id');
      return docking;
    }
  }

  Future<void> deleteDocking(String id) async {
    await apiService.delete('dockings/$id');
  }

  Future<void> syncDockings() async {
    SimpleLogger.info('Syncing dockings');

    // Try to fetch new data from the server and update local storage
    try {
      var serverDockingIds = await getDockingIdsFromServer();
      await fetchAndStoreNewDockings(serverDockingIds);
    } catch (e) {
      SimpleLogger.warning('Error fetching dockings from server: $e');
      // If fetching from server fails, use local data
    }

    // Sync any pending updates from local storage to the server
    var pendingDockings =
        await localStorageService.getPendingData('dockings', 'status');
    for (var pending in pendingDockings) {
      try {
        var response;
        if (pending['status'] == 'pending_creation') {
          response = await apiService.post('dockings/create', pending);
        } else if (pending['status'] == 'pending_update') {
          response = await apiService.put('dockings/${pending['id']}', pending);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          //   await localStorageService.insertOrUpdate('dockings', pending, 'id');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending docking: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (existing methods) ...

  // Add a method to update local storage with new data from the server
  Future<void> fetchAndStoreNewDockings(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final dockingData = await apiService.get('dockings/$id');
        final docking = Docking.fromJson(dockingData);
        //  await localStorageService.insertOrUpdate(
        //     'dockings', docking.toJson(), 'id');
      } catch (e) {
        SimpleLogger.warning('Failed to fetch docking: $id, error: $e');
        // Continue with the next ID if one fetch fails
      }
    }
  }

  Future<void> updateLocalDatabase(List<Docking> serverDockings) async {
    // Clear local data
    await localStorageService.clearTable('dockings');

    // Insert new data into the local database
    for (var docking in serverDockings) {
      await localStorageService.insertData('dockings', docking.toJson());
    }
  }

  //getDockingIdsFromServer returns a list of docking ids
  Future<List<String>> getDockingIdsFromServer() async {
    final data = await apiService.get('dockings/ids');
    return (data as List).map((item) => item.toString()).toList();
  }
}
