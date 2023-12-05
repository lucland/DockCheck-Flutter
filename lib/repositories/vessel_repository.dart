import 'package:cripto_qr_googlemarine/models/vessel.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

import '../utils/simple_logger.dart';

class VesselRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  VesselRepository(this.apiService, this.localStorageService);

  Future<Vessel> createVessel(Vessel vessel) async {
    final data = await apiService.post('vessels/create', vessel.toJson());
    return Vessel.fromJson(data);
  }

  Future<Vessel> getVessel(String id) async {
    final data = await apiService.get('vessels/$id');
    SimpleLogger.info('Vessel: $data');
    return Vessel.fromJson(data);
  }

  Future<List<Vessel>> getVesselsByName(String name) async {
    final data = await apiService.get('vessels/name/$name');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  Future<Vessel> updateVessel(String id, Vessel vessel) async {
    final data = await apiService.put('vessels/$id', vessel.toJson());
    return Vessel.fromJson(data);
  }

  Future<void> deleteVessel(String id) async {
    await apiService.delete('vessels/$id');
  }

  Future<List<Vessel>> getVesselsByCompany(String companyId) async {
    final data = await apiService.get('vessels/company/$companyId');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  Future<List<Vessel>> getAllVessels() async {
    final data = await apiService.get('vessels');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  //get onboarded users of a vessel with /vessels/onboarded/{id}/
  Future<List<String>> getOnboardedUsers(String id) async {
    final data = await apiService.get('vessels/onboarded/$id');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> syncVessels() async {
    try {
      final localIds = await localStorageService.getIds('vessels');
      final serverIds = await getAllVesselsIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewVessels(newIds).then(
            (value) => SimpleLogger.fine('Vessel synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Vessel synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Vessel synchronization failed');
    }
  }

// Implement fetchAndStoreNewVessels similarly

  Future<void> updateLocalDatabase(List<Vessel> serverVessels) async {
    // Clear local data
    await localStorageService.clearTable('vessels');

    // Insert new data into the local database
    for (var vessel in serverVessels) {
      await localStorageService.insertData('vessels', vessel.toJson());
    }
  }

  //get all vessels ids from server with /vessels/ids
  Future<List<String>> getAllVesselsIdsFromServer() async {
    final data = await apiService.get('vessels/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> fetchAndStoreNewVessels(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('vessels/$id');
      final auth = Vessel.fromJson(authData);
      await localStorageService.insertData('vessels', auth.toJson());
    }
  }
}
