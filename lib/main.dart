import 'package:easy_hire/core/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'core/screens/welcome_page.dart';
import 'core/screens/forgot_password_page.dart';
import 'core/screens/login_page.dart';
import 'core/screens/sign_up_page.dart';
import 'core/screens/sign_up_next_page.dart';
import 'core/screens/verify_code_page.dart';
import 'core/screens/reset_password_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/signup': (context) => SignUpPage(),
        '/signup-next': (context) => SignUpNextPage(),
        '/home': (context) => HomePage(),

        '/verify_code': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return VerifyCodePage(
            isEmailReset: args['isEmailReset'],
            identifier: args['identifier'],
          );
        },
        '/reset_password': (context) => ResetPasswordPage(),
      },
    );
  }
}
