import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../constants/app_styles.dart';

class SignInScreen extends StatelessWidget {
  final String title;

  const SignInScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            margin: const EdgeInsets.all(AppStyles.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const SignInForm(),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isPhoneSignIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputField(
          label: isPhoneSignIn ? "Номер телефону" : "Пошта",
          keyboardType:
              isPhoneSignIn ? TextInputType.phone : TextInputType.emailAddress,
        ),
        const SizedBox(height: AppStyles.spacing),
        const InputField(label: "Пароль", obscureText: true),
        const SizedBox(height: AppStyles.spacing),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () {}, child: const Text('Увійти')),
        ),

        const SizedBox(height: AppStyles.spacing),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isPhoneSignIn = !isPhoneSignIn;
                });
              },
              child: Text(
                isPhoneSignIn
                    ? 'Увійти через пошту'
                    : 'Увійти через номер телефону',
                style: TextStyle(
                  color: AppStyles.focusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
