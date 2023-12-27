import 'package:dockcheck/models/picture.dart';
import 'package:dockcheck/services/api_service.dart';

class PictureRepository {
  final ApiService apiService;

  PictureRepository(this.apiService);

  Future<Picture> createPicture(Picture picture) async {
    final data = await apiService.post('api/v1/pictures', picture.toJson());
    return Picture.fromJson(data);
  }

  Future<Picture> getPicture(String id) async {
    final data = await apiService.get('api/v1/pictures/$id');
    return Picture.fromJson(data);
  }

  Future<Picture> updatePicture(String id, Picture picture) async {
    final data = await apiService.put('api/v1/pictures/$id', picture.toJson());
    return Picture.fromJson(data);
  }

  Future<void> deletePicture(String id) async {
    await apiService.delete('api/v1/pictures/$id');
  }
}
