import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/app_styles.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '+380 (00) 000-00-00');
  final _passwordController = TextEditingController();

  void _onNext(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        '/signup-next',
        arguments: {
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );
    }
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hintText: "Пошта",
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(Icons.email_outlined, color: AppStyles.secondaryColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введіть ваш email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Невірний формат пошти';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      hintText: "Номер телефону",
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      prefixIcon: Icon(Icons.phone_outlined, color: AppStyles.secondaryColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Будь ласка, введіть номер телефону';
        }
        if (!_phoneController.text.contains(
          RegExp(r'\d{2}\) \d{3}-\d{2}-\d{2}'),
        )) {
          return 'Невірний формат номера';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      hintText: "Пароль",
      controller: _passwordController,
      obscureText: true,
      prefixIcon: Icon(Icons.lock_outline, color: AppStyles.secondaryColor),
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Пароль має бути не менше 6 символів';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(
          context,
        ).requestFocus(FocusNode()); // знімає фокус з інпутів
      },
      child: Scaffold(
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

                    _buildEmailField(),
                    SizedBox(height: AppStyles.verticalSpacing),

                    _buildPhoneField(),
                    SizedBox(height: AppStyles.verticalSpacing),

                    _buildPasswordField(),
                    SizedBox(height: AppStyles.verticalSpacing),

                    CustomButton(
                      text: "Наступний",
                      onPressed: () => _onNext(context),
                    ),

                    SizedBox(height: AppStyles.verticalSpacing * 2),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Вже маєте акаунт? ",
                            style: TextStyle(
                              color: AppStyles.textSecondaryColor,
                            ),
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
      ),
    );
  }
}
