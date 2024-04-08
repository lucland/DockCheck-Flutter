import 'package:dockcheck/models/area.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class AreaRepository {
  final ApiService apiService;

  AreaRepository(this.apiService);

  Future<Area?> createArea(Area area) async {
    try {
      final data = await apiService.post('areas/create', area.toJson());
      SimpleLogger.info("201 - Area created successfully");
      return Area.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error creating area");
      return null;
    }
  }

  Future<Area?> getArea(String id) async {
    try {
      final data = await apiService.get('areas/$id');
      SimpleLogger.info("200 - Area fetched successfully");
      return Area.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error fetching area");
      return null;
    }
  }

  Future<List<Area>> getAllAreas() async {
    try {
      final data = await apiService.get('areas');
      SimpleLogger.info("200 - Areas fetched successfully");
      return (data as List).map((item) => Area.fromJson(item)).toList();
    } catch (error) {
      SimpleLogger.severe("400 - Error fetching areas");
      return [];
    }
  }

  Future<Area?> updateArea(String id, Area area) async {
    try {
      final data = await apiService.put('areas/$id', area.toJson());
      SimpleLogger.info("200 - Area updated successfully");
      return Area.fromJson(data);
    } catch (error) {
      SimpleLogger.severe("400 - Error updating area");
      return null;
    }
  }

  Future<void> deleteArea(String id) async {
    try {
      await apiService.delete('areas/$id');
      SimpleLogger.info("200 - Area deleted successfully");
    } catch (error) {
      SimpleLogger.severe("400 - Error deleting area");
    }
  }
}
