import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import '../services/payment_service.dart';
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String userId;

  const PaymentScreen({required this.amount, required this.userId, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (_) => setState(() => _isLoading = false),
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('success')) {
                  Navigator.pop(context, 'success');
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );

    Future.microtask(() => _loadPaymentForm());
  }

  Future<void> _loadPaymentForm() async {
    try {
      final paymentService = PaymentService();
      final paymentData = await paymentService.createPayment(
        amount: widget.amount,
        userId: widget.userId,
      );

      final htmlEscape = const HtmlEscape();
      final data = htmlEscape.convert(paymentData['data']!);
      final signature = htmlEscape.convert(paymentData['signature']!);

      final htmlContent = '''
        <html>
          <body onload="document.forms[0].submit();">
            <form method="POST" action="https://www.liqpay.ua/api/3/checkout" accept-charset="utf-8">
              <input type="hidden" name="data" value="$data" />
              <input type="hidden" name="signature" value="$signature" />
            </form>
          </body>
        </html>
      ''';

      await _controller.loadHtmlString(htmlContent);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка при завантаженні LiqPay: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата через LiqPay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, 'cancel'),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
