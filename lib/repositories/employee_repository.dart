import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class EmployeeRepository {
  final ApiService apiService;

  EmployeeRepository(this.apiService);

  Future<Employee?> createEmployee(Employee employee) async {
    try {
      final data = await apiService.post('employees/create', employee.toJson());
      SimpleLogger.info('Employee created successfully');
      return Employee.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error creating employee: $error');
      return null;
    }
  }

  Future<void> blockEmployee(String id, String blockReason) async {
    try {
      await apiService
          .put('employees/$id/block', {'block_reason': blockReason});
      SimpleLogger.info('Employee blocked successfully');
    } catch (error) {
      SimpleLogger.severe('Error blocking employee: $error');
    }
  }

  Future<Employee?> getEmployee(String id) async {
    try {
      final data = await apiService.get('employees/$id');
      SimpleLogger.info('Employee fetched successfully');
      return Employee.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching employee: $error');
      return null;
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    try {
      final data = await apiService.get('employees');
      SimpleLogger.info('All employees fetched successfully');
      return List<Employee>.from(data.map((item) => Employee.fromJson(item)));
    } catch (error) {
      SimpleLogger.severe('Error fetching all employees: $error');
      return [];
    }
  }

  Future<Employee?> updateEmployee(String id, Employee employee) async {
    try {
      final data = await apiService.put('employees/$id', employee.toJson());
      SimpleLogger.info('Employee updated successfully');
      return Employee.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating employee: $error');
      return null;
    }
  }

  Future<void> updateEmployeeArea(
      String id, String lastAreaFound, String lastTimeFound) async {
    try {
      await apiService.put('employees/$id/updateArea',
          {'last_area_found': lastAreaFound, 'last_time_found': lastTimeFound});
      SimpleLogger.info('Employee area updated successfully');
    } catch (error) {
      SimpleLogger.severe('Error updating employee area: $error');
    }
  }
}
