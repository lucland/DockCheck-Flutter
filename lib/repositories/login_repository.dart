import 'dart:convert';

import '../services/api_service.dart';
import '../utils/simple_logger.dart';

class LoginRepository {
  final ApiService apiService;

  LoginRepository(this.apiService);

  Future<Map<String, dynamic>> login(
      String username, String password, String role, String system) async {
    print("repo login callled");
    try {
      final response = await apiService.postLogin(
        'login',
        {
          'username': username,
          'password': password,
          'role': role,
          'system': system,
        },
      );

      if (response.containsKey('error')) {
        SimpleLogger.warning("User login failed");
        return response; // Contains error details
      } else {
        SimpleLogger.info("User logged in");
        await _storeUserData(response); // Store user data on successful login
        return response; // Successful login data
      }
    } catch (e) {
      SimpleLogger.severe("Login failed: ${e.toString()}");
      return {'error': 'Login failed', 'details': e.toString()};
    }
  }

  Future<bool> logout() async {
    final userId = await apiService.localStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      SimpleLogger.warning("User ID is null or empty");
      return false;
    }

    try {
      final response = await apiService.postLogin(
        'logout', // Assuming the endpoint for logout is 'logout'
        {'user_id': userId},
      );

      if (response.containsKey('error')) {
        SimpleLogger.warning("User logout failed");
        return false;
      } else {
        SimpleLogger.info("User logged out");
        await _clearUserData();
        return true;
      }
    } catch (e) {
      SimpleLogger.severe("Logout failed: ${e.toString()}");
      return false;
    }
  }

  Future<void> _storeUserData(Map<String, dynamic> userData) async {
    await apiService.localStorageService.saveToken(userData['token']);
    await apiService.localStorageService
        .saveUserId(userData['user_id'].toString());
    // Store other user data as needed
  }

  Future<void> _clearUserData() async {
    await apiService.localStorageService.deleteToken();
    await apiService.localStorageService.deleteUserId();
    // Clear other user data as needed
  }
}
