import 'package:dockcheck/models/company.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/simple_logger.dart';

class CompanyRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  CompanyRepository(this.apiService, this.localStorageService);

  Future<Company> createCompany(Company company) async {
    try {
      final data = await apiService.post('companies/create', company.toJson());
      SimpleLogger.info('Company created: $data');
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
      return [];
    }
  }

  Future<Company> updateCompany(String id, Company company) async {
    try {
      final data = await apiService.put('companies/$id', company.toJson());
      SimpleLogger.info('Company updated: $data');
      return Company.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update company: ${e.toString()}');
      company.status = 'pending_update';
      return company;
    }
  }

  Future<void> deleteCompany(String id) async {
    await apiService.delete('companies/$id');
  }

  Future<void> syncCompanies() async {
    SimpleLogger.info('Syncing companies');

    try {
      var serverCompanies = await getCompanyIdsFromServer();
      await fetchAndStoreNewCompanies(serverCompanies);
    } catch (e) {
      SimpleLogger.warning('Error fetching companies from server: $e');
    }

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
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending company: $e');
      }
    }
  }

  Future<void> fetchAndStoreNewCompanies(List<String> newIds) async {
    for (String id in newIds) {
      try {
        final companyData = await apiService.get('companies/$id');
        final company = Company.fromJson(companyData);
        await localStorageService.insertData('companies', company.toJson());
      } catch (e) {
        SimpleLogger.warning('Failed to fetch company: $id, error: $e');
      }
    }
  }

  Future<List<String>> getCompanyIdsFromServer() async {
    final data = await apiService.get('companies/ids');
    return (data as List).map((item) => item.toString()).toList();
  }
}
