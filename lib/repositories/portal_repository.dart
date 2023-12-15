import 'package:dockcheck/models/portal.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';

import '../utils/simple_logger.dart';

class PortalRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  PortalRepository(this.apiService, this.localStorageService);

  Future<Portal> createPortal(Portal portal) async {
    await localStorageService.insertOrUpdate('portals', portal.toJson(), 'id');

    try {
      final data = await apiService.post('portals/create', portal.toJson());
      await localStorageService.insertOrUpdate(
          'portals', Portal.fromJson(data).toJson(), 'id');
      return Portal.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create portal: ${e.toString()}');
      return portal;
    }
  }

  Future<Portal> getPortal(String id) async {
    try {
      final data = await apiService.get('portals/$id');
      return Portal.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get portal: ${e.toString()}');
      final localData = await localStorageService.getDataById('portals', id);
      return Portal.fromJson(localData);
    }
  }

  Future<Portal> updatePortal(String id, Portal portal) async {
    try {
      final data = await apiService.put('portals/$id', portal.toJson());
      await localStorageService.insertOrUpdate(
          'portals', Portal.fromJson(data).toJson(), 'id');
      return Portal.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update portal: ${e.toString()}');
      portal.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'portals', portal.toJson(), 'id');
      return portal;
    }
  }

  Future<void> deletePortal(String id) async {
    await apiService.delete('portals/$id');
  }

  Future<List<Portal>> getAllPortals() async {
    final data = await apiService.get('portals');
    return (data as List).map((item) => Portal.fromJson(item)).toList();
  }

  Future<List<Portal>> getPortalsByVessel(String vesselId) async {
    final data = await apiService.get('portals/vessel/$vesselId');
    return (data as List).map((item) => Portal.fromJson(item)).toList();
  }

  // Modified syncPortals Method
  Future<void> syncPortals() async {
    SimpleLogger.info('Syncing portals');

    // First, try to fetch new data from the server
    try {
      var serverPortals = await apiService.get('portals');
      await updateLocalDatabase(
          serverPortals); // Update local database with new data
    } catch (e) {
      SimpleLogger.warning('Error fetching portals from server: $e');
      // If fetching from server fails, use local data
    }

    // Then, sync any pending updates from local storage to the server
    var pendingPortals =
        await localStorageService.getPendingData('portals', 'status');
    for (var pending in pendingPortals) {
      try {
        var response = await apiService.post('portals/create', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('portals', pending, 'id');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending portal: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  Future<void> updateLocalDatabase(List<Portal> serverPortals) async {
    for (var portal in serverPortals) {
      var localData =
          await localStorageService.getDataById('portals', portal.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('portals', portal.toJson());
      } else {
        await localStorageService.updateData('portals', portal.toJson(), 'id');
      }
    }
  }

  //getPortalIdsFromServer returns a list of portal ids
  Future<List<String>> getPortalIdsFromServer() async {
    final data = await apiService.get('portals/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> fetchAndStoreNewPortals(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('portals/$id');
      final auth = Portal.fromJson(authData);
      await localStorageService.insertData('portals', auth.toJson());
    }
  }
}
