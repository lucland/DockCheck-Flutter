import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/models/receptor.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class ReceptorRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  ReceptorRepository(this.apiService, this.localStorageService);

  Future<Receptor> createReceptor(Receptor receptor) async {
    await localStorageService.insertOrUpdate(
        'receptors', receptor.toJson(), 'id');

    try {
      final data = await apiService.post('receptors/create', receptor.toJson());
      await localStorageService.insertOrUpdate(
          'receptors', Receptor.fromJson(data).toJson(), 'id');
      SimpleLogger.info('Receptor created: $data');
      return Receptor.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create receptor: ${e.toString()}');
      return receptor;
    }
  }

  Future<Receptor> getReceptorById(String id) async {
    try {
      final data = await apiService.get('receptors/$id');
      SimpleLogger.info('Receptor retrieved: $data');
      return Receptor.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to retrieve receptor: ${e.toString()}');
      final localData = await localStorageService.getDataById('receptors', id);
      return Receptor.fromJson(localData);
    }
  }

  Future<Receptor> updateReceptor(String id, Receptor receptor) async {
    try {
      final data = await apiService.put('receptors/$id', receptor.toJson());
      await localStorageService.insertOrUpdate(
          'receptors', Receptor.fromJson(data).toJson(), 'id');
      SimpleLogger.info('Receptor updated: $data');
      return Receptor.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update receptor: ${e.toString()}');
      receptor.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'receptors', receptor.toJson(), 'id');
      return receptor;
    }
  }

  Future<void> deleteReceptor(String id) async {
    SimpleLogger.info('Receptor deleted: $id');
    await apiService.delete('receptors/$id');
  }

  Future<List<Receptor>> getAllReceptors() async {
    final data = await apiService.get('receptors');
    SimpleLogger.info('Receptors retrieved: $data');
    return (data as List).map((item) => Receptor.fromJson(item)).toList();
  }

  Future<void> syncReceptors() async {
    SimpleLogger.info('Syncing receptors');

    // Try to fetch new data from the server and update local storage
    try {
      var serverReceptors = await apiService.get('receptors');
      await updateLocalDatabase(serverReceptors);
    } catch (e) {
      SimpleLogger.warning('Error fetching receptors from server: $e');
      // If fetching from server fails, use local data
    }

    // Sync any pending updates from local storage to the server
    var pendingReceptors =
        await localStorageService.getPendingData('receptors', 'status');
    for (var pending in pendingReceptors) {
      try {
        var response = await apiService.post('receptors/create', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('receptors', pending, 'id');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending receptor: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // Add a method to update local storage with new data from the server
  Future<void> updateLocalDatabase(List<Receptor> serverReceptors) async {
    for (var receptor in serverReceptors) {
      var localData =
          await localStorageService.getDataById('receptors', receptor.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('receptors', receptor.toJson());
      } else {
        await localStorageService.updateData(
            'receptors', receptor.toJson(), 'id');
      }
    }
  }
}
