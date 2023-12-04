import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';
import 'package:cripto_qr_googlemarine/models/docking.dart';

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

  // Sync dockings from the server and update local database
  Future<void> syncDockings() async {
    try {
      // Fetch data from the server
      final serverDockings = await getAllDockings();

      // Update local database
      await updateLocalDatabase(serverDockings);
    } catch (e) {
      // Handle errors
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
}
