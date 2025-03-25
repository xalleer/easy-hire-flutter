import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

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
    return await makeRequest(
      endpoint: '/api/tasks/$taskId/accept',
      method: 'POST',
      token: token,
    );
  }
}
