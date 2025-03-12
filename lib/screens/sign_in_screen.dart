import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../constants/app_styles.dart';
import '../widgets/button.dart';
import '../widgets/fade_switcher.dart';

class SignInForm extends StatelessWidget {
  final bool isPhoneSignIn;

  const SignInForm({super.key, required this.isPhoneSignIn});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeSwitcher(
          child: InputField(
            key: ValueKey(isPhoneSignIn),
            label: isPhoneSignIn ? "Номер телефону" : "Пошта",
            keyboardType:
                isPhoneSignIn
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: AppStyles.spacing),
        const InputField(label: "Пароль", obscureText: true),
        const SizedBox(height: AppStyles.spacing),

        SizedBox(
          width: double.infinity,
          child: Button(text: 'Увійти', isLoading: false, onPressed: () {}),
        ),
      ],
    );
  }
}

class SignInScreen extends StatefulWidget {
  final String title;

  const SignInScreen({super.key, required this.title});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isPhoneSignIn = false;

  void toggleSignInMethod() {
    setState(() {
      isPhoneSignIn = !isPhoneSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                child: SignInForm(isPhoneSignIn: isPhoneSignIn),
              ),
              const SizedBox(height: AppStyles.spacing),
              GestureDetector(
                onTap: toggleSignInMethod,
                child: FadeSwitcher(
                  child: Text(
                    isPhoneSignIn
                        ? 'Увійти через пошту'
                        : 'Увійти через номер телефону',
                    key: ValueKey(isPhoneSignIn),
                    style: TextStyle(
                      color: AppStyles.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
