import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/simple_logger.dart';
import 'local_storage_service.dart';

class ApiService {
  //Emulator:
  //final String baseUrl = 'http://10.0.2.2:3000/api/v1';
  //Local:
  //final String baseUrl = 'http://localhost:3000/api/v1';
  //Device:
  final String baseUrl = 'https://gmarineinnovation.com/api/v1';
  //
  final LocalStorageService localStorageService;

  ApiService(this.localStorageService);

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    SimpleLogger.info('Response: ${response.body}');
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> postLogin(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      SimpleLogger.info(
          "postLogin response: Status Code: ${response.statusCode}, Body: ${response.body}");

      if (response.statusCode == 200) {
        // Assuming the response body is a JSON object
        return jsonDecode(response.body);
      } else {
        // Handling non-200 responses
        return {
          'error': 'Login failed',
          'statusCode': response.statusCode,
          'details': response.body
        };
      }
    } catch (e) {
      SimpleLogger.severe("Error in postLogin: ${e.toString()}");
      return {'error': 'Exception in login', 'details': e.toString()};
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
    );
    return _processResponse(response);
  }

  Future<Map<String, String>> _getHeaders() async {
    String? token = await localStorageService.getToken();

    return token != null
        ? {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
        : {
            'Content-Type': 'application/json',
          };
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      SimpleLogger.fine('Success: ${response.body}');
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      jsonResponse['statusCode'] =
          response.statusCode; // Add the status code to the response
      SimpleLogger.info('Response: $jsonResponse');
      return jsonResponse;
    } else {
      SimpleLogger.severe('Error: ${response.body}');
      throw Exception('Failed to process request: ${response.statusCode}');
    }
  }
}
