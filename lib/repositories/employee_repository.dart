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

  Future<Employee> getEmployeeById(String id) async {
    final data = await apiService.get('employees/$id');
    return Employee.fromJson(data);
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

    //get all employees by employee.user_id
  Future<List<Employee>> getEmployeesByUserId(String userId) async {
    try {
      print("userId: $userId");
      final data = await apiService.get('employees/user/$userId');
      print("Data fetched: $data");
      return (data as List).map((item) => Employee.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe(
          'Failed to get employees by user id: ${e.toString()}');
      return [];
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    final data = await apiService.get('employees');
    if (data != null && data is List) {
      print("Data fetched: $data");
      var list = (data).map((item) => Employee.fromJson(item)).toList();
      print("First employee name: ${list.first.name}"); // More detailed log
      return list;
    } else {
      print("Data fetched is null");
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
