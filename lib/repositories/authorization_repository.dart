import '../models/authorization.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class AuthorizationRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AuthorizationRepository(this.apiService, this.localStorageService);

  Future<Authorization> createAuthorization(Authorization authorization) async {
    final data =
        await apiService.post('authorizations', authorization.toJson());
    return Authorization.fromJson(data);
  }

  Future<List<Authorization>> getAuthorizations(String userId) async {
    final data = await apiService.get('authorizations/$userId');
    var authorizations =
        (data as List).map((item) => Authorization.fromJson(item)).toList();

    SimpleLogger.info('Authorizations: $authorizations');
    return authorizations;
  }

  Future<Authorization> getAuthorizationById(String id) async {
    final data = await apiService.get('authorizations/$id');
    return Authorization.fromJson(data);
  }

  Future<Authorization> updateAuthorization(
      String id, Authorization authorization) async {
    final data =
        await apiService.put('authorizations/$id', authorization.toJson());
    return Authorization.fromJson(data);
  }

  Future<void> deleteAuthorization(String id) async {
    await apiService.delete('authorizations/$id');
  }

  Future<void> syncAuthorizations() async {
    try {
      final localIds = await localStorageService.getIds('authorizations');
      final serverIds = await getAuthorizationIdsFromServer();

      final newIds = serverIds.where((id) => !localIds.contains(id)).toList();

      if (newIds.isNotEmpty) {
        await fetchAndStoreNewAuthorizations(newIds).then(
            (value) =>
                SimpleLogger.fine('Authorization synchronization completed'),
            onError: (e) =>
                SimpleLogger.severe('Authorization synchronization failed'));
      }
    } catch (e) {
      SimpleLogger.severe('Authorization synchronization failed');
    }
  }

  Future<List<Authorization>> getAuthorizationsFromServer() async {
    final data = await apiService.get('authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

  Future<void> updateLocalDatabase(
      List<Authorization> serverAuthorizations) async {
    // Clear local data or implement a more sophisticated update logic
    await localStorageService.clearTable('authorizations');

    // Insert fetched data into the local database
    for (var auth in serverAuthorizations) {
      await localStorageService.insertData('authorizations', auth.toJson());
    }
  }

  //getAuthorizationIdsFromServer returns a list of authorization ids
  Future<List<String>> getAuthorizationIdsFromServer() async {
    final data = await apiService.get('authorizations/ids');
    return (data as List).map((item) => item.toString()).toList();
  }

  Future<void> fetchAndStoreNewAuthorizations(List<String> newIds) async {
    for (String id in newIds) {
      final authData = await apiService.get('authorizations/$id');
      final auth = Authorization.fromJson(authData);
      await localStorageService.insertData('authorizations', auth.toJson());
    }
  }
}
