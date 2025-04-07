import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'dart:convert';

class AuthApi extends ApiService {
  Future<Map<String, dynamic>?> signUpUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required List<String> workLocations,
    required List<String> skills,
  }) async {
    return await makeRequest(
      endpoint: '/api/auth/register',
      method: 'POST',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': 'worker',
        'workLocations': workLocations,
        'skills': skills,
      },
    );
  }

  Future<Map<String, dynamic>?> loginEmailUser({
    required String email,
    required String password,
  }) async {
    final response = await makeRequest(
      endpoint: '/api/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
    );

    if (response['status'] == 'error') {
      print('Помилка: ${response['message']}');
      return null;
    }

    if (response['token'] != null) {
      print('Токен отримано: ${response['token']}');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = response['token'];
      await prefs.setString('authToken', token);
      await prefs.setString('userInfo', jsonEncode(response['user']));
      return response;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginPhoneUser({
    required String phone,
    required String password,
  }) async {
    return await makeRequest(
      endpoint: '/api/auth/login',
      method: 'POST',
      body: {'phone': phone, 'password': password},
    );
  }

  Future<Map<String, dynamic>?> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return {'status': 'success', 'message': 'Ви вийшли успішно'};
    } catch (e) {
      return {'status': 'error', 'message': 'Помилка при виході: $e'};
    }
  }

  Future<Map<String, dynamic>?> requestPasswordResetEmail({
    required String email,
  }) async {
    return await makeRequest(
      endpoint: '/api/auth/forgot-password',
      method: 'POST',
      body: {'email': email},
    );
  }

  Future<Map<String, dynamic>?> verifyResetCode({
    required String identifier,
    required String code,
  }) async {
    return await makeRequest(
      endpoint: '/api/auth/verify-code',
      method: 'POST',
      body: {'email': identifier, 'code': code},
    );
  }
}
