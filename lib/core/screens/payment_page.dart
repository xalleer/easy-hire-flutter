import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'dart:io' show Platform;

class PaymentPage extends StatefulWidget {
  final String htmlContent;

  const PaymentPage({required this.htmlContent, super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    print("PaymentPage initialized with HTML: ${widget.htmlContent}");
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                print("Page started loading: $url");
              },
              onPageFinished: (String url) {
                print("Page finished loading: $url");
              },
              onHttpError: (HttpResponseError error) {
                print("HTTP Error occurred: ${error.toString()}");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("HTTP Error occurred")),
                );
              },
              onWebResourceError: (WebResourceError error) {
                print("Web Resource Error: ${error.description}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${error.description}")),
                );
              },
              onNavigationRequest: (NavigationRequest request) {
                // Перевіряємо callback URL від LiqPay
                if (request.url.contains(
                  'https://your-backend.com/api/payment/webhook',
                )) {
                  print("Callback received: ${request.url}");
                  // Повертаємо результат оплати назад у BalancePage
                  Navigator.pop(context, "Payment completed: ${request.url}");
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );

    if (widget.htmlContent.isNotEmpty) {
      _controller.loadRequest(
        Uri.dataFromString(
          widget.htmlContent,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
    } else {
      print("Error: HTML content is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No HTML content provided")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Оплата LiqPay")),
      body:
          widget.htmlContent.isNotEmpty
              ? WebViewWidget(controller: _controller)
              : const Center(child: Text("No content to display")),
    );
  }
}
