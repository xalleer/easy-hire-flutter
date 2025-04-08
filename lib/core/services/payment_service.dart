import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String _apiBaseUrl =
      'https://easy-hire-backend-gules.vercel.app/api/payment';

  Future<String> createTopUp({
    required double amount,
    required String userId,
  }) async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/topup?userId=$userId');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // У відповіді приходить html
        return json['html'];
      } else {
        print('Сервер повернув помилку: ${response.statusCode}');
        throw Exception('Помилка при створенні платежу');
      }
    } catch (e) {
      print('Помилка у createTopUp: $e');
      throw Exception('Помилка при створенні платежу');
    }
  }
}
