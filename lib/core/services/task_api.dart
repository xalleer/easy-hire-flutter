import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'dart:convert';

class TaskApi extends ApiService {
  Future<dynamic> getAllTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    return await makeRequest(
      endpoint: '/api/tasks/all',
      method: 'GET',
      token: token,
    );
  }

  Future<Map<String, dynamic>?> acceptTask(String taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    String? userInfoJson = prefs.getString('userInfo');

    if (userInfoJson == null) {
      throw Exception("User info not found in storage");
    }

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    String workerId = userInfo['id'] ?? userInfo['_id'];

    return await makeRequest(
      endpoint:
          '/api/tasks/accept?taskId=$taskId&workerId=$workerId&needTransport=false',
      method: 'PUT',
      token: token,
    );
  }

  Future<dynamic> getAcceptedTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    String? userInfoJson = prefs.getString('userInfo');
    if (userInfoJson == null) {
      throw Exception("User info not found in storage");
    }

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    String workerId = userInfo['id'] ?? userInfo['_id'];
    return await makeRequest(
      endpoint: '/api/tasks/accepted-tasks?workerId=$workerId',
      method: 'GET',
      token: token,
    );
  }

  Future<dynamic> cancelTask(String taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    String? userInfoJson = prefs.getString('userInfo');

    if (userInfoJson == null) {
      throw Exception("User info not found in storage");
    }

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    String workerId = userInfo['id'] ?? userInfo['_id'];

    return await makeRequest(
      endpoint:
          '/api/tasks/decline?taskId=$taskId&userId=$workerId&userRole=worker',
      method: 'PUT',
      token: token,
    );
  }
}
