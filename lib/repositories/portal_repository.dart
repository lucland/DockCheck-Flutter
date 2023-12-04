import 'package:cripto_qr_googlemarine/models/portal.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

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

  // Sync portals from the server and update local database
  Future<void> syncPortals() async {
    try {
      // Fetch data from the server
      final serverPortals = await getAllPortals();

      // Update local database
      await updateLocalDatabase(serverPortals);
    } catch (e) {
      // Handle errors
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
}
