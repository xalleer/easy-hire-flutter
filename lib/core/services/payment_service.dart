import 'dart:convert';
import 'package:crypto/crypto.dart'; // Потрібно додати пакет 'crypto'

class PaymentService {
  final String _publicKey = 'sandbox_i71604838073'; // Публічний ключ LiqPay
  final String _privateKey =
      'sandbox_8GxyXbuAP5ofe58iVmZDenfXAk5oJeLwI9PR9tHZ'; // Приватний ключ LiqPay

  Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String userId,
  }) async {
    try {
      print('Створення платежу: amount=$amount, userId=$userId');

      final Map<String, dynamic> data = {
        'version': '3',
        'public_key': _publicKey,
        'action': 'pay',
        'amount': amount.toString(), // Перетворюємо в рядок для коректності
        'currency': 'UAH',
        'description': 'Поповнення балансу',
        'order_id': 'order_${userId}_${DateTime.now().millisecondsSinceEpoch}',
        'result_url': 'https://www.google.com/',
        'server_url': 'https://www.google.com/',
      };

      // Перетворюємо Map у JSON-стрічку
      final String jsonData = jsonEncode(data);

      // Кодуємо JSON у base64
      final String base64Data = base64Encode(utf8.encode(jsonData));

      // Створюємо підпис: privateKey + base64Data + privateKey
      final String dataToSign = _privateKey + base64Data + _privateKey;
      final String signature = _generateSignature(dataToSign);

      // Повертаємо відповідь
      return {
        'data': base64Data, // Base64-кодовані дані
        'signature': signature, // Підпис
      };
    } catch (e) {
      print('Помилка в PaymentService: $e');
      throw Exception('Помилка при створенні платежу: $e');
    }
  }

  // Генерація підпису за допомогою SHA1 і кодування в base64
  String _generateSignature(String data) {
    final bytes = utf8.encode(data); // Перетворюємо рядок у байти
    final digest = sha1.convert(bytes); // Генеруємо SHA1 хеш
    return base64Encode(digest.bytes); // Кодуємо хеш у base64 і повертаємо
  }
}
