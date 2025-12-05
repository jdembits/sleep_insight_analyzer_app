import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://your-backend-endpoint.com/analyze";

  static Future<Map<String, dynamic>> sendSleepData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {"result": decoded};
      } else {
        return {"error": "Server responded with status: ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": "Failed to connect to server: $e"};
    }
  }
}