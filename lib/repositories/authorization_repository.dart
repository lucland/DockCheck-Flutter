import '../models/authorization.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class AuthorizationRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AuthorizationRepository(this.apiService, this.localStorageService);

  Future<Authorization> createAuthorization(Authorization authorization) async {
    await localStorageService.insertOrUpdate(
        'authorizations', authorization.toJson(), 'id');

    try {
      final data =
          await apiService.post('authorizations', authorization.toJson());
      await localStorageService.insertOrUpdate(
          'authorizations', Authorization.fromJson(data).toJson(), 'id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to create authorization: ${e.toString()}');
      return authorization;
    }
  }

  Future<Authorization> getAuthorizationById(String id) async {
    try {
      final data = await apiService.get('authorizations/$id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to get authorization: ${e.toString()}');
      final localData =
          await localStorageService.getDataById('authorizations', id);
      return Authorization.fromJson(localData);
    }
  }

  Future<Authorization> updateAuthorization(
      String id, Authorization authorization) async {
    try {
      final data =
          await apiService.put('authorizations/$id', authorization.toJson());
      await localStorageService.insertOrUpdate(
          'authorizations', Authorization.fromJson(data).toJson(), 'id');
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update authorization: ${e.toString()}');
      authorization.status = 'pending_update'; // Assuming 'status' field exists
      await localStorageService.insertOrUpdate(
          'authorizations', authorization.toJson(), 'id');
      return authorization;
    }
  }

  Future<List<Authorization>> getAuthorizations(String userId) async {
    final data = await apiService.get('authorizations/$userId');
    var authorizations =
        (data as List).map((item) => Authorization.fromJson(item)).toList();

    SimpleLogger.info('Authorizations: $authorizations');
    return authorizations;
  }

  Future<void> deleteAuthorization(String id) async {
    await apiService.delete('authorizations/$id');
  }

  /* Future<void> syncAuthorizations() async {
    SimpleLogger.info('Syncing authorizations');
    var pendingAuthorizations =
        await localStorageService.getPendingData('authorizations', 'status');

    for (var pending in pendingAuthorizations) {
      try {
        var response = await apiService.post('authorizations', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate(
              'authorizations', pending, 'id');
        }
      } catch (e) {
        // Handle API call failure
        SimpleLogger.severe('Authorization synchronization failed');
        throw Exception('Authorization synchronization failed');
      }
    }
  }*/

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

  Future<void> syncPendingAuthorizations() async {
    SimpleLogger.info('Syncing authorizations');
    var pendingAuthorizations =
        await localStorageService.getPendingData('authorizations', 'status');

    for (var pending in pendingAuthorizations) {
      try {
        var response = await apiService.post('authorizations', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          await localStorageService.insertOrUpdate(
              'authorizations', pending, 'id');
          SimpleLogger.info('Authorization synchronized');
        }
      } catch (e) {
        // Handle API call failure
        SimpleLogger.severe('Authorization synchronization failed');
        throw Exception('Authorization synchronization failed');
      }
    }
  }
}
