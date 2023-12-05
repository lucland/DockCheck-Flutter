import 'package:cripto_qr_googlemarine/models/supervisor.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

class SupervisorRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  SupervisorRepository(this.apiService, this.localStorageService);

  Future<Supervisor> createSupervisor(Supervisor supervisor) async {
    final data =
        await apiService.post('supervisors/create', supervisor.toJson());
    return Supervisor.fromJson(data);
  }

  Future<Supervisor> getSupervisor(String id) async {
    final data = await apiService.get('supervisors/$id');
    return Supervisor.fromJson(data);
  }

  Future<Supervisor> updateSupervisor(String id, Supervisor supervisor) async {
    final data = await apiService.put('supervisors/$id', supervisor.toJson());
    return Supervisor.fromJson(data);
  }

  Future<void> deleteSupervisor(String id) async {
    await apiService.delete('supervisors/$id');
  }

  Future<List<Supervisor>> getAllSupervisors() async {
    final data = await apiService.get('supervisors');
    return (data as List).map((item) => Supervisor.fromJson(item)).toList();
  }

  Future<void> updateLocalDatabase(List<Supervisor> serverSupervisors) async {
    // Clear local data
    await localStorageService.clearTable('supervisors');

    // Insert new data into the local database
    for (var supervisor in serverSupervisors) {
      await localStorageService.insertData('supervisors', supervisor.toJson());
    }
  }
}
