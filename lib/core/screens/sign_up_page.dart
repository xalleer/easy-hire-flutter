import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/app_styles.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phoneController = MaskedTextController(mask: '+380 (00) 000-00-00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Реєстрація", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyles.formPadding,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Персональна інформація",
                    style: AppStyles.headingStyle.copyWith(fontSize: 18),
                  ),
                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomTextField(
                    hintText: "Пошта",
                    controller: emailController,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppStyles.secondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введіть ваш email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomTextField(
                    hintText: "Номер телефону",
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Будь ласка, введіть номер телефону';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: AppStyles.secondaryColor,
                    ),
                  ),
                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomTextField(
                    hintText: "Пароль",
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppStyles.secondaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Пароль має бути не менше 6 символів';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomButton(
                    text: "Наступний",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(
                          context,
                          '/signup-next',
                          arguments: {
                            'email': emailController.text,
                            'phone': phoneController.text,
                            'password': passwordController.text,
                          },
                        );
                      }
                    },
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Вже маєте аккаунт? ",
                          style: TextStyle(color: AppStyles.textSecondaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Увійти",
                            style: TextStyle(
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
