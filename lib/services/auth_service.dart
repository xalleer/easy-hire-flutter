import 'package:shared_preferences/shared_preferences.dart';
import './api-services.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  static const String AUTH_TOKEN_KEY = 'auth_token';

  Future<User> signIn(String login, String password) async {
    final response = await _apiService.post('auth/login', {
      'login': login,
      'password': password,
    });

    final token = response['token'];
    final user = User.fromJson(response['user']);

    await _saveAuthToken(token);
    _apiService.setAuthToken(token);

    return user;
  }

  Future<User> signUp(
    String phone,
    String email,
    String password,
    String role,
  ) async {
    final response = await _apiService.post('auth/register', {
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    });

    final token = response['token'];
    final user = User.fromJson(response['user']);

    await _saveAuthToken(token);
    _apiService.setAuthToken(token);

    return user;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTH_TOKEN_KEY);
  }

  Future<bool> isAuthenticated() async {
    final token = await _getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AUTH_TOKEN_KEY, token);
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN_KEY);
  }
}
