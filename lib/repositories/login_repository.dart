import 'dart:convert';

import 'package:cripto_qr_googlemarine/utils/simple_logger.dart';

import '../services/api_service.dart';

class LoginRepository {
  final ApiService apiService;

  LoginRepository(this.apiService);

  Future<Map<String, dynamic>> login(
      String username, String password, String role, String system) async {
    final response = await apiService.postLogin(
      'login',
      {
        'username': username,
        'password': password,
        'role': role,
        'system': system,
      },
    );
    if (response.statusCode == 200) {
      SimpleLogger.info("User logged in");
    } else {
      SimpleLogger.warning("User login failed");
    }

    return jsonDecode(response.body);
  }

  Future<bool> logout() async {
    final userId = await apiService.localStorageService.getUserId();

    if (userId == null || userId.isEmpty) {
      print("User ID is null or empty");
      SimpleLogger.warning("User ID is null or empty");
      return false;
    }

    final response = await apiService.postLogin(
      'login/logout',
      {'user_id': userId},
    );

    if (response.statusCode == 200) {
      await apiService.localStorageService.deleteToken();
      await apiService.localStorageService.deleteUser();
      await apiService.localStorageService.deleteUsername();
      await apiService.localStorageService.deleteUserId();
      SimpleLogger.info("User logged out");
      return true;
    }

    return false;
  }
}
