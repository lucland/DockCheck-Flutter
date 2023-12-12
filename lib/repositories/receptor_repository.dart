import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/models/receptor.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class ReceptorRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  ReceptorRepository(this.apiService, this.localStorageService);

  Future<Receptor> createReceptor(Receptor receptor) async {
    final data = await apiService.post('receptors/create', receptor.toJson());
    SimpleLogger.info('Receptor created: $data');
    return Receptor.fromJson(data);
  }

  Future<Receptor> getReceptorById(String id) async {
    final data = await apiService.get('receptors/$id');
    SimpleLogger.info('Receptor retrieved: $data');
    return Receptor.fromJson(data);
  }

  Future<Receptor> updateReceptor(String id, Receptor receptor) async {
    final data = await apiService.put('receptors/$id', receptor.toJson());
    SimpleLogger.info('Receptor updated: $data');
    return Receptor.fromJson(data);
  }

  Future<void> deleteReceptor(String id) async {
    SimpleLogger.info('Receptor deleted: $id');
    await apiService.delete('receptors/$id');
  }

  Future<List<Receptor>> getAllReceptors() async {
    final data = await apiService.get('receptors');
    SimpleLogger.info('Receptors retrieved: $data');
    return (data as List).map((item) => Receptor.fromJson(item)).toList();
  }
}
