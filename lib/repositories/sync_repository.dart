import '../services/api_service.dart';
import '../utils/simple_logger.dart';

class SyncController {
  final ApiService apiService;

  SyncController(this.apiService);

  Future<void> sync() async {
    try {
      await apiService.post('sync', {});
      SimpleLogger.info('Sync completed successfully');
    } catch (error) {
      SimpleLogger.severe('Error during sync: $error');
    }
  }
}
