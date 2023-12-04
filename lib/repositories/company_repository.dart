import 'package:cripto_qr_googlemarine/services/api_service.dart';
import 'package:cripto_qr_googlemarine/models/company.dart';

import '../services/local_storage_service.dart';

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

  // Sync companies from the server and update local database
  Future<void> syncCompanies() async {
    try {
      // Fetch data from the server
      final serverCompanies = await getAllCompanies();

      // Update local database
      await updateLocalDatabase(serverCompanies);
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> updateLocalDatabase(List<Company> serverCompanies) async {
    // Clear local data
    await localStorageService.clearTable('companies');

    // Insert new data into the local database
    for (var company in serverCompanies) {
      await localStorageService.insertData('companies', company.toJson());
    }
  }
}
