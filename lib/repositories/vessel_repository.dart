import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';

import '../utils/simple_logger.dart';

class VesselRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  VesselRepository(this.apiService, this.localStorageService);

  Future<Vessel> getVessel(String id) async {
    try {
      final data = await apiService.get('vessels/$id');
      SimpleLogger.info('Vessel: $data');
      return Vessel.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get vessel from API: ${e.toString()}');
      // Fetching from local storage as a fallback
      final localData = await localStorageService.getDataById('vessels', id);
      if (localData.isNotEmpty) {
        SimpleLogger.info('Fetched vessel from local storage');
        return Vessel.fromJson(localData);
      } else {
        throw Exception('Vessel not found locally');
      }
    }
  }

  Future<List<Vessel>> getVesselsByName(String name) async {
    try {
      final data = await apiService.get('vessels/name/$name');
      return (data as List).map((item) => Vessel.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get vessels by name: ${e.toString()}');
      // Implement logic to fetch data from local storage if needed
      // Return data from local storage or empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<Vessel> updateVessel(String id, Vessel vessel) async {
    try {
      final data = await apiService.put('vessels/$id', vessel.toJson());
      return Vessel.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update vessel: ${e.toString()}');
      vessel.status = 'pending_update';
      await localStorageService.insertOrUpdate(
          'vessels', vessel.toJson(), 'id');
      return vessel;
    }
  }

  Future<void> deleteVessel(String id) async {
    try {
      await apiService.delete('vessels/$id');
    } catch (e) {
      SimpleLogger.severe('Failed to delete vessel: ${e.toString()}');
      // Handle deletion failure
    }
  }

  Future<List<Vessel>> getVesselsByCompany(String companyId) async {
    try {
      final data = await apiService.get('vessels/company/$companyId');
      return (data as List).map((item) => Vessel.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get vessels by company: ${e.toString()}');
      // Implement logic to fetch data from local storage if needed
      // Return data from local storage or empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<List<Vessel>> getAllVessels() async {
    try {
      final data = await apiService.get('vessels');
      return (data as List).map((item) => Vessel.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get all vessels: ${e.toString()}');
      // Implement logic to fetch data from local storage if needed
      // Return data from local storage or empty list
      return []; // Return an empty list as a fallback
    }
  }

  //get onboarded users of a vessel with /vessels/onboarded/{id}/
  Future<List<String>> getOnboardedUsers(String id) async {
    final data = await apiService.get('vessels/onboarded/$id');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<Vessel> createVessel(Vessel vessel) async {
    try {
      final data = await apiService.post('vessels/create', vessel.toJson());
      await localStorageService.insertOrUpdate(
          'vessels', Vessel.fromJson(data).toJson(), 'id');
      return Vessel.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create vessel: ${e.toString()}');
      vessel.status = 'pending_creation'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'vessels', vessel.toJson(), 'id');
      return vessel;
    }
  }

  // ... (remaining CRUD methods) ...

  Future<void> syncPendingVessels() async {
    SimpleLogger.info('Syncing vessels');
    var pendingVessels =
        await localStorageService.getPendingData('vessels', 'status');

    for (var pending in pendingVessels) {
      try {
        var response;
        if (pending['status'] == 'pending_creation') {
          response = await apiService.post('vessels/create', pending);
        } else if (pending['status'] == 'pending_update') {
          response = await apiService.put('vessels/${pending['id']}', pending);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('vessels', pending, 'id');
          SimpleLogger.info('Vessel synchronized');
        }
      } catch (e) {
        SimpleLogger.severe('Failed to sync pending vessel: ${e.toString()}');
        // If syncing fails, leave it as pending
      }
    }
  }

  Future<void> updateLocalDatabase(List<Vessel> serverVessels) async {
    for (var vessel in serverVessels) {
      var localData =
          await localStorageService.getDataById('vessels', vessel.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('vessels', vessel.toJson());
      } else {
        await localStorageService.updateData('vessels', vessel.toJson(), 'id');
      }
    }
  }

  Future<void> fetchAndStoreNewVessels(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final vesselData = await apiService.get('vessels/$id');
        final vessel = Vessel.fromJson(vesselData);
        await localStorageService.insertOrUpdate(
            'vessels', vessel.toJson(), 'id');
      } catch (e) {
        SimpleLogger.warning('Failed to fetch vessel: $id, error: $e');
        // Continue with the next ID if one fetch fails
      }
    }
  }

  //get all vessels ids from server with /vessels/ids
  Future<List<String>> getAllVesselsIdsFromServer() async {
    final data = await apiService.get('vessels/ids');
    return (data as List).map((item) => item.toString()).toList();
  }
}
