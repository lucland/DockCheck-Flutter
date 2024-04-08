import '../models/authorization.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../utils/simple_logger.dart';

class AuthorizationRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AuthorizationRepository(this.apiService, this.localStorageService);

  Future<Authorization> createAuthorization(Authorization authorization) async {
    try {
      final data =
          await apiService.post('authorizations', authorization.toJson());
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

  Future<List<Authorization>> getAuthorizations(String userId) async {
    try {
      final data = await apiService.get('authorizations/user/$userId');
      return (data as List)
          .map((item) => Authorization.fromJson(item))
          .toList();
    } catch (e) {
      SimpleLogger.severe('Failed to get authorizations: ${e.toString()}');
      return [];
    }
  }

  Future<Authorization> updateAuthorization(
      String id, Authorization authorization) async {
    try {
      final data =
          await apiService.put('authorizations/$id', authorization.toJson());
      return Authorization.fromJson(data);
    } catch (e) {
      SimpleLogger.severe('Failed to update authorization: ${e.toString()}');
      authorization.status = 'pending_update';
      return authorization;
    }
  }

  Future<void> deleteAuthorization(String id) async {
    await apiService.delete('authorizations/$id');
  }

  Future<List<Authorization>> getAuthorizationsFromServer() async {
    final data = await apiService.get('authorizations');
    return (data as List).map((item) => Authorization.fromJson(item)).toList();
  }

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

  Future<void> syncAuthorizations() async {
    SimpleLogger.info('Syncing authorizations');

    try {
      var serverAuthorizations = await getAuthorizationsFromServer();
      await updateLocalDatabase(serverAuthorizations);
    } catch (e) {
      SimpleLogger.warning('Error fetching authorizations from server: $e');
    }

    var pendingAuthorizations =
        await localStorageService.getPendingData('authorizations', 'status');
    for (var pending in pendingAuthorizations) {
      try {
        var response = await apiService.post('authorizations', pending);
        if (response.statusCode == 200 || response.statusCode == 201) {
          pending['status'] = 'synced';
          SimpleLogger.info('Authorization synchronized');
        }
      } catch (e) {
        SimpleLogger.warning('Error syncing pending authorization: $e');
      }
    }
  }

  Future<void> updateLocalDatabase(
      List<Authorization> serverAuthorizations) async {
    for (var auth in serverAuthorizations) {
      var localData =
          await localStorageService.getDataById('authorizations', auth.id);
      if (localData.isEmpty) {
        await localStorageService.insertData('authorizations', auth.toJson());
      } else {
        await localStorageService.updateData(
            'authorizations', auth.toJson(), 'id');
      }
    }
  }
}
