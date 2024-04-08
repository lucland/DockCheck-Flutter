import 'package:dockcheck/models/sensor.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class SensorRepository {
  final ApiService apiService;

  SensorRepository(this.apiService);

  Future<Sensor?> createSensor(Sensor sensor) async {
    try {
      final data = await apiService.post('sensors/create', sensor.toJson());
      SimpleLogger.info('Sensor created successfully');
      return Sensor.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error creating sensor: $error');
      return null;
    }
  }

  Future<Sensor?> getSensorById(String sensorId) async {
    try {
      final data = await apiService.get('sensors/$sensorId');
      SimpleLogger.info('Sensor fetched successfully');
      return Sensor.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching sensor: $error');
      return null;
    }
  }

  Future<List<Sensor>> getAllSensors() async {
    try {
      final data = await apiService.get('sensors');
      SimpleLogger.info('All sensors fetched successfully');
      return List<Sensor>.from(data.map((item) => Sensor.fromJson(item)));
    } catch (error) {
      SimpleLogger.severe('Error fetching all sensors: $error');
      return [];
    }
  }

  Future<Sensor?> updateSensor(String sensorId, Sensor sensor) async {
    try {
      final data = await apiService.put('sensors/$sensorId', sensor.toJson());
      SimpleLogger.info('Sensor updated successfully');
      return Sensor.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating sensor: $error');
      return null;
    }
  }

  Future<Sensor?> updateBeaconsFound(String sensorId, int beaconsFound) async {
    try {
      final data = await apiService
          .put('sensors/$sensorId/beacons', {'beacons_found': beaconsFound});
      SimpleLogger.info('Beacons found updated successfully');
      return Sensor.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating beacons found: $error');
      return null;
    }
  }

  Future<Sensor?> updateSensorLocation(
      String sensorId, double locationX, double locationY) async {
    try {
      final data = await apiService.put('sensors/$sensorId/location',
          {'location_x': locationX, 'location_y': locationY});
      SimpleLogger.info('Sensor location updated successfully');
      return Sensor.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating sensor location: $error');
      return null;
    }
  }
}
