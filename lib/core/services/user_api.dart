import 'package:easy_hire/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserApi extends ApiService {
  Future<dynamic> getMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');
    String? token = prefs.getString('authToken');

    if (userInfoJson == null) {
      throw Exception("User info not found in storage");
    }

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    String userId = userInfo['id'] ?? userInfo['_id'];

    return await makeRequest(
      endpoint: '/api/user/me/$userId',
      method: 'GET',
      token: token,
    );
  }

  Future<dynamic> changeStatus(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');
    String? token = prefs.getString('authToken');

    if (userInfoJson == null) {
      throw Exception("User info not found in storage");
    }

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    String userId = userInfo['id'] ?? userInfo['_id'];

    return await makeRequest(
      endpoint: '/api/user/change-status?userId=$userId&status=$status',
      method: 'PUT',
      token: token,
    );
  }
}
