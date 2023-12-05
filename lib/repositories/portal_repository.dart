import 'package:cripto_qr_googlemarine/models/portal.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

import '../utils/simple_logger.dart';

class PortalRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  PortalRepository(this.apiService, this.localStorageService);

  Future<Portal> createPortal(Portal portal) async {
    final data = await apiService.post('portals/create', portal.toJson());
    return Portal.fromJson(data);
  }

  Future<Portal> getPortal(String id) async {
    final data = await apiService.get('portals/$id');
    return Portal.fromJson(data);
  }

  Future<Portal> updatePortal(String id, Portal portal) async {
    final data = await apiService.put('portals/$id', portal.toJson());
    return Portal.fromJson(data);
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

  Future<void> syncPortals() async {
    try {
      final localIds = await localStorageService.getIds('portals');
      final serverIds = await getPortalIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewPortals(newIds).then(
            (value) => SimpleLogger.fine('Portal synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Portal synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Portal synchronization failed');
    }
  }

  Future<void> updateLocalDatabase(List<Portal> serverPortals) async {
    // Clear local data
    await localStorageService.clearTable('portals');

    // Insert new data into the local database
    for (var portal in serverPortals) {
      await localStorageService.insertData('portals', portal.toJson());
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
