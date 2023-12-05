import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/models/company.dart';

import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class CompanyRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  CompanyRepository(this.apiService, this.localStorageService);

  Future<Company> createCompany(Company company) async {
    final data = await apiService.post('companies/create', company.toJson());
    return Company.fromJson(data);
  }

  Future<Company> getCompany(String id) async {
    final data = await apiService.get('companies/$id');
    return Company.fromJson(data);
  }

  Future<Company> updateCompany(String id, Company company) async {
    final data = await apiService.put('companies/$id', company.toJson());
    return Company.fromJson(data);
  }

  Future<void> deleteCompany(String id) async {
    await apiService.delete('companies/$id');
  }

  Future<List<Company>> getAllCompanies() async {
    final data = await apiService.get('companies');
    return (data as List).map((item) => Company.fromJson(item)).toList();
  }

  Future<void> syncCompanies() async {
    try {
      final localIds = await localStorageService.getIds('companies');
      final serverIds = await getCompanyIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewCompanies(newIds).then(
            (value) => SimpleLogger.fine('Companies synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Companies synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Companies synchronization failed');
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

  //fetch an store new companies
  Future<void> fetchAndStoreNewCompanies(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('companies/$id');
      final auth = Company.fromJson(authData);
      await localStorageService.insertData('companies', auth.toJson());
    }
  }
}
