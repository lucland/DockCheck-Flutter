import 'package:dockcheck/models/supervisor.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';

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

  Future<void> syncPendingSupervisors() async {
    SimpleLogger.info('Syncing Supervisors');
    var pendingSupervisors =
        await localStorageService.getPendingData('supervisors', 'status');

    for (var pending in pendingSupervisors) {
      try {
        var response;
        if (pending['status'] == 'pending_creation') {
          response = await apiService.post('supervisors/create', pending);
        } else if (pending['status'] == 'pending_update') {
          response =
              await apiService.put('supervisors/${pending['id']}', pending);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate(
              'supervisors', pending, 'id');
          SimpleLogger.info('Supervisor synchronized');
        }
      } catch (e) {
        SimpleLogger.severe(
            'Failed to sync pending supervisor: ${e.toString()}');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (fetch and store new supervisors method if needed) ...

  Future<void> updateLocalDatabase(List<Supervisor> serverSupervisors) async {
    for (var supervisor in serverSupervisors) {
      var localData =
          await localStorageService.getDataById('supervisors', supervisor.id);
      if (localData.isEmpty) {
        await localStorageService.insertData(
            'supervisors', supervisor.toJson());
      } else {
        await localStorageService.updateData(
            'supervisors', supervisor.toJson(), 'id');
      }
    }
  }
}
