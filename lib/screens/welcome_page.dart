import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import '../widgets/button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Image.asset(
              'assets/images/easy-hire-bg-white.png',
              height: 300,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Text("Увійдіть або зареєструйтесь"),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Увійти',
                    isLoading: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SignInScreen(title: "Увійти"),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Зареєструватися',
                    isLoading: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const SignUpScreen(title: "Зареєструватися"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
