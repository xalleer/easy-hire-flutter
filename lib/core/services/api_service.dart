import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://easy-hire-backend-gules.vercel.app';

  Future<dynamic> makeRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      http.Response response;
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw Exception('Непідтримуваний HTTP метод: $method');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // Повертаємо сирі дані
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': 'error',
          'message':
              errorData['message'] ?? 'Помилка сервера: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Помилка запиту: $e'};
    }
  }
}
