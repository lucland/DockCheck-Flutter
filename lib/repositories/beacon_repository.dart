import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/models/beacon.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class BeaconRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  BeaconRepository(this.apiService, this.localStorageService);

  Future<Beacon> createBeacon(Beacon beacon) async {
    final data = await apiService.post('beacons/create', beacon.toJson());
    SimpleLogger.info('Beacon created: $data');
    return Beacon.fromJson(data);
  }

  Future<Beacon> getBeacon(String id) async {
    final data = await apiService.get('beacons/$id');
    SimpleLogger.info('Beacon retrieved: $data');
    return Beacon.fromJson(data);
  }

  Future<Beacon> updateBeacon(String id, Beacon beacon) async {
    final data = await apiService.put('beacons/$id', beacon.toJson());
    SimpleLogger.info('Beacon updated: $data');
    return Beacon.fromJson(data);
  }

  Future<void> deleteBeacon(String id) async {
    SimpleLogger.info('Beacon deleted: $id');
    await apiService.delete('beacons/$id');
  }

  Future<List<Beacon>> getAllBeacons() async {
    final data = await apiService.get('beacons');
    SimpleLogger.info('Beacons retrieved: $data');
    return (data as List).map((item) => Beacon.fromJson(item)).toList();
  }

  // Add other methods as needed, following the structure of your CompanyRepository
}
