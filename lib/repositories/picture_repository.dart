import 'package:dockcheck/models/picture.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class PictureRepository {
  final ApiService apiService;

  PictureRepository(this.apiService);

  Future<Picture?> createEmployeePicture(
      String id, String employeeId, String base64, String docPath) async {
    try {
      final response = await apiService.post(
        'createEmployeePicture',
        {
          'id': id,
          'employee_id': employeeId,
          'base_64': base64,
          'doc_path': docPath,
        },
      );

      if (response != null && !response.containsKey('error')) {
        SimpleLogger.info("Picture created successfully");
        return Picture.fromJson(response);
      } else {
        SimpleLogger.warning("Error creating picture: ${response['error']}");
        return null;
      }
    } catch (e) {
      SimpleLogger.severe("Failed to create picture: ${e.toString()}");
      return null;
    }
  }

  Future<Picture?> getPicture(String id) async {
    try {
      final response = await apiService.get('getPicture/$id');
      if (response != null && !response.containsKey('error')) {
        SimpleLogger.info("Picture retrieved successfully");
        return Picture.fromJson(response);
      } else {
        SimpleLogger.warning("Error getting picture: ${response['error']}");
        return null;
      }
    } catch (e) {
      SimpleLogger.severe("Failed to get picture: ${e.toString()}");
      return null;
    }
  }

  Future<Picture?> updatePicture(String id, Picture picture) async {
    try {
      final response =
          await apiService.put('updatePicture/$id', picture.toJson());
      if (response != null && !response.containsKey('error')) {
        SimpleLogger.info("Picture updated successfully");
        return Picture.fromJson(response);
      } else {
        SimpleLogger.warning("Error updating picture: ${response['error']}");
      }
    } catch (e) {
      SimpleLogger.severe("Failed to update picture: ${e.toString()}");
      return null;
    }
  }

  Future<bool> deletePicture(String id) async {
    try {
      final response = await apiService.delete('deletePicture/$id');
      if (response != null && !response.containsKey('error')) {
        SimpleLogger.info("Picture deleted successfully");
        return true;
      } else {
        SimpleLogger.warning("Error deleting picture: ${response['error']}");
        return false;
      }
    } catch (e) {
      SimpleLogger.severe("Failed to delete picture: ${e.toString()}");
      return false;
    }
  }
}
