import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/models/company.dart';

import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class CompanyRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  CompanyRepository(this.apiService, this.localStorageService);

  Future<Company> createCompany(Company company) async {
    await localStorageService.insertOrUpdate(
        'companies', company.toJson(), 'id');

    try {
      final data = await apiService.post('companies/create', company.toJson());
      await localStorageService.insertOrUpdate(
          'companies', Company.fromJson(data).toJson(), 'id');
      return Company.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create company: ${e.toString()}');
      return company;
    }
  }

  Future<Company> getCompany(String id) async {
    try {
      final data = await apiService.get('companies/$id');
      return Company.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get company: ${e.toString()}');
      final localData = await localStorageService.getDataById('companies', id);
      return Company.fromJson(localData);
    }
  }

  Future<List<Company>> getAllCompanies() async {
    try {
      final data = await apiService.get('companies');
      return (data as List).map((item) => Company.fromJson(item)).toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get all companies: ${e.toString()}');
      // Fetch from local storage as fallback
      // Implement logic to return data from local storage or an empty list
      return []; // Return an empty list as a fallback
    }
  }

  Future<Company> updateCompany(String id, Company company) async {
    try {
      final data = await apiService.put('companies/$id', company.toJson());
      await localStorageService.insertOrUpdate(
          'companies', Company.fromJson(data).toJson(), 'id');
      return Company.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update company: ${e.toString()}');
      company.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'companies', company.toJson(), 'id');
      return company;
    }
  }

  Future<void> deleteCompany(String id) async {
    await apiService.delete('companies/$id');
  }

  Future<void> syncCompanies() async {
    SimpleLogger.info('Syncing companies');

    // Try to fetch new data from the server and update local storage
    try {
      var serverCompanies = await getCompanyIdsFromServer();
      await fetchAndStoreNewCompanies(serverCompanies);
    } catch (e) {
      SimpleLogger.warning('Error fetching companies from server: $e');
      // If fetching from server fails, use local data
    }

    // Sync any pending updates from local storage to the server
    var pendingCompanies =
        await localStorageService.getPendingData('companies', 'status');
    for (var pending in pendingCompanies) {
      try {
        var response;
        if (pending['status'] == 'pending_creation') {
          response = await apiService.post('companies/create', pending);
        } else if (pending['status'] == 'pending_update') {
          response =
              await apiService.put('companies/${pending['id']}', pending);
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate('companies', pending, 'id');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending company: $e');
        // If syncing fails, leave it as pending
      }
    }
  }

  // ... (existing methods) ...

  // Add a method to update local storage with new data from the server
  Future<void> fetchAndStoreNewCompanies(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final companyData = await apiService.get('companies/$id');
        final company = Company.fromJson(companyData);
        await localStorageService.insertOrUpdate(
            'companies', company.toJson(), 'id');
      } catch (e) {
        SimpleLogger.warning('Failed to fetch company: $id, error: $e');
        // Continue with the next ID if one fetch fails
      }
    }
  }

// Implement fetchAndStoreNewCompanies similarly

  Future<void> updateLocalDatabase(List<Company> serverCompanies) async {
    // Clear local data
    await localStorageService.clearTable('companies');

    // Insert new data into the local database
    for (var company in serverCompanies) {
      await localStorageService.insertData('companies', company.toJson());
    }
  }

  //get all companies ids from server with /companies/ids
  Future<List<String>> getCompanyIdsFromServer() async {
    final data = await apiService.get('companies/ids');
    return (data as List).map((item) => item.toString()).toList();
  }
}
