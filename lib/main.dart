import 'package:flutter/material.dart';
import 'core/screens/welcome_page.dart';
import 'core/screens/login_page.dart';
import 'core/screens/sign_up_page.dart';
import 'core/screens/sign_up_next_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/signup-next': (context) => SignUpNextPage(),
      },
    );
  }
}
