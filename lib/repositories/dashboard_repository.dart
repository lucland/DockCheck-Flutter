import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/third_company.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class DashboardRepository {
  final ApiService apiService;

  DashboardRepository(this.apiService);

  Future getAreaAccessCount(
      String projectId, String startDate, String endDate) async {
    try {
      final data = await apiService.post('Dashboard/getAreaAccessCount', {
        'projectId': projectId,
        'startDate': startDate,
        'endDate': endDate,
      });
      SimpleLogger.info('Area access count fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe('Error fetching area access count: $error');
      return null;
    }
  }

  Future getThirdCompanyHours(
      String projectId, String startDate, String endDate) async {
    try {
      final data = await apiService.post('Dashboard/getThirdCompanyHours', {
        'projectId': projectId,
        'startDate': startDate,
        'endDate': endDate,
      });
      SimpleLogger.info('Third company hours fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe('Error fetching third company hours: $error');
      return null;
    }
  }

  Future getThirdCompanyAccessCount(
      String projectId, String startDate, String endDate) async {
    try {
      final data =
          await apiService.post('Dashboard/getThirdCompanyAccessCount', {
        'projectId': projectId,
        'startDate': startDate,
        'endDate': endDate,
      });
      SimpleLogger.info('Third company access count fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe('Error fetching third company access count: $error');
      return null;
    }
  }

  Future getTotalUniqueEmployees(String projectId) async {
    try {
      final data = await apiService.post('Dashboard/getTotalUniqueEmployees', {
        'projectId': projectId,
      });
      SimpleLogger.info('Total unique employees fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe('Error fetching total unique employees: $error');
      return null;
    }
  }

  Future getCurrentPeopleOnboarded(String projectId) async {
    try {
      final data =
          await apiService.post('Dashboard/getCurrentPeopleOnboarded', {
        'projectId': projectId,
      });
      SimpleLogger.info('Current people onboarded fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe('Error fetching current people onboarded: $error');
      return null;
    }
  }

  Future getUniqueThirdCompaniesOnboarded(String projectId) async {
    try {
      final data =
          await apiService.post('Dashboard/getUniqueThirdCompaniesOnboarded', {
        'projectId': projectId,
      });
      SimpleLogger.info(
          'Unique third companies onboarded fetched successfully');
      return data;
    } catch (error) {
      SimpleLogger.severe(
          'Error fetching unique third companies onboarded: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getOnboardedEmployeesDetails(
      String projectId) async {
    try {
      final data =
          await apiService.post('Dashboard/getOnboardedEmployeesDetails', {
        'projectId': projectId,
      });
      SimpleLogger.info('Onboarded employees details fetched successfully');
      return List<Map<String, dynamic>>.from(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching onboarded employees details: $error');
      return null;
    }
  }
}
