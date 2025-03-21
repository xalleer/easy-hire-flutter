import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://easy-hire-backend-gules.vercel.app';

  Future<Map<String, dynamic>?> signUpUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required List<String> workLocations,
    required List<String> skills,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "role": "worker",
          "workLocations": workLocations,
          "skills": skills,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("❌ Помилка реєстрації: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Помилка запиту: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginEmailUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Помилка логіну: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Помилка запиту: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginPhoneUser({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ Помилка логіну: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Помилка запиту: $e");
      return null;
    }
  }
}
