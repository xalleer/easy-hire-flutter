import 'package:easy_hire/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_hire/services/api-services.dart';
import 'package:easy_hire/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_hire/providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ProxyProvider<ApiService, AuthService>(
          update: (_, apiService, __) => AuthService(apiService),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create:
              (context) => AuthProvider(
                Provider.of<AuthService>(context, listen: false),
              ),
          update:
              (_, authService, previous) =>
                  previous ?? AuthProvider(authService),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: WelcomePage(),
      ),
    );
  }
}
