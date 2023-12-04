import 'package:cripto_qr_googlemarine/models/vessel.dart';
import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';

class VesselRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  VesselRepository(this.apiService, this.localStorageService);

  Future<Vessel> createVessel(Vessel vessel) async {
    final data = await apiService.post('vessel/create', vessel.toJson());
    return Vessel.fromJson(data);
  }

  Future<Vessel> getVessel(String id) async {
    final data = await apiService.get('vessel/$id');
    return Vessel.fromJson(data);
  }

  Future<List<Vessel>> getVesselsByName(String name) async {
    final data = await apiService.get('vessel/name/$name');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  Future<Vessel> updateVessel(String id, Vessel vessel) async {
    final data = await apiService.put('vessel/$id', vessel.toJson());
    return Vessel.fromJson(data);
  }

  Future<void> deleteVessel(String id) async {
    await apiService.delete('vessel/$id');
  }

  Future<List<Vessel>> getVesselsByCompany(String companyId) async {
    final data = await apiService.get('vessel/company/$companyId');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  Future<List<Vessel>> getAllVessels() async {
    final data = await apiService.get('vessels');
    return (data as List).map((item) => Vessel.fromJson(item)).toList();
  }

  // Sync vessels from the server and update the local database
  Future<void> syncVessels() async {
    try {
      // Fetch data from the server
      final serverVessels = await getAllVessels();

      // Update local database
      await updateLocalDatabase(serverVessels);
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> updateLocalDatabase(List<Vessel> serverVessels) async {
    // Clear local data
    await localStorageService.clearTable('vessels');

    // Insert new data into the local database
    for (var vessel in serverVessels) {
      await localStorageService.insertData('vessels', vessel.toJson());
    }
  }
}
