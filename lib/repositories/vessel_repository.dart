import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class VesselRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  VesselRepository(this.apiService, this.localStorageService);

  Future<Vessel?> createVessel(Vessel vessel) async {
    try {
      final data = await apiService.post('vessels/create', vessel.toJson());
      SimpleLogger.info("201 - Vessel created successfully");
      return Vessel.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error creating vessel");
      return null;
    }
  }

  Future<Vessel?> getVessel(String id) async {
    try {
      final data = await apiService.get('vessels/$id');
      SimpleLogger.info("200 - Vessel fetched successfully");
      return Vessel.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error fetching vessel");
      return null;
    }
  }

  Future<Vessel?> updateVessel(String id, Vessel vessel) async {
    try {
      final data = await apiService.put('vessels/$id', vessel.toJson());
      SimpleLogger.info("200 - Vessel updated successfully");
      return Vessel.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error updating vessel");
      return null;
    }
  }

  Future<void> deleteVessel(String id) async {
    try {
      await apiService.delete('vessels/$id');
      SimpleLogger.info("204 - Vessel deleted successfully");
    } catch (error) {
      SimpleLogger.severe("400 - Error deleting vessel");
    }
  }

  Future<List<Vessel>> getVesselsByCompany(String companyId) async {
    try {
      final data = await apiService.get('vessels/company/$companyId');
      SimpleLogger.info("200 - Vessels fetched successfully");
      return (data as List).map((item) => Vessel.fromJson(item)).toList();
    } catch (error) {
      SimpleLogger.severe("400 - Error fetching vessels");
      return [];
    }
  }

  Future<List<Vessel>> getAllVessels() async {
    try {
      final data = await apiService.get('vessels');
      SimpleLogger.info("200 - Vessels fetched successfully");
      return (data as List).map((item) => Vessel.fromJson(item)).toList();
    } catch (error) {
      SimpleLogger.severe("400 - Error fetching vessels");
      return [];
    }
  }
}
