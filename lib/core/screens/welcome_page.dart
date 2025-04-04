import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../constants/app_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0)),
            Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                text: "Увійти",
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                text: "Зареєструватися",
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
