import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';
import 'package:cripto_qr_googlemarine/models/docking.dart';

import '../utils/simple_logger.dart';

class DockingRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  DockingRepository(this.apiService, this.localStorageService);

  Future<Docking> createDocking(Docking docking) async {
    final data = await apiService.post('dockings/create', docking.toJson());
    return Docking.fromJson(data);
  }

  Future<Docking> getDocking(String id) async {
    final data = await apiService.get('dockings/$id');
    return Docking.fromJson(data);
  }

  Future<Docking> updateDocking(String id, Docking docking) async {
    final data = await apiService.put('dockings/$id', docking.toJson());
    return Docking.fromJson(data);
  }

  Future<void> deleteDocking(String id) async {
    await apiService.delete('dockings/$id');
  }

  Future<List<Docking>> getAllDockings() async {
    final data = await apiService.get('dockings');
    return (data as List).map((item) => Docking.fromJson(item)).toList();
  }

  Future<void> syncDockings() async {
    try {
      final localIds = await localStorageService.getIds('dockings');
      final serverIds = await getDockingIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewDockings(newIds).then(
            (value) => SimpleLogger.fine('Docking synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Docking synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Docking synchronization failed');
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

  Future<void> fetchAndStoreNewDockings(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('dockings/$id');
      final auth = Docking.fromJson(authData);
      await localStorageService.insertData('dockings', auth.toJson());
    }
  }
}
