import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/app_styles.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage();

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  bool isLoading = false;

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // try {
    //   final response = await apiService.resetPassword(
    //     identifier: widget.identifier,
    //     code: widget.code,
    //     newPassword: passwordController.text,
    //   );

    //   if (response != null && response['status'] != 'error') {
    //     _showSuccessSnackBar("✅ Пароль успішно змінено");
    //     Navigator.pushNamedAndRemoveUntil(
    //       context,
    //       '/login',
    //       (route) => false, // Повертаємося на сторінку логіну, очищаючи стек
    //     );
    //   } else {
    //     _showErrorSnackBar("❌ ${response?['message'] ?? 'Не вдалося змінити пароль'}");
    //   }
    // } catch (e) {
    //   _showErrorSnackBar("❌ Помилка: ${e.toString()}");
    // } finally {
    //   setState(()   {
    //     isLoading = false;
    //   });
    // }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.errorColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Зміна пароля", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppStyles.formPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Введіть новий пароль",
                    style: AppStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing),
                  Text(
                    "Створіть новий пароль для вашого акаунту.",
                    style: TextStyle(color: AppStyles.textSecondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  CustomTextField(
                    hintText: "Новий пароль",
                    controller: passwordController,
                    obscureText: true,
                    validator: Validators.passwordValidator,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppStyles.secondaryColor,
                    ),
                  ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomTextField(
                    hintText: "Підтвердіть пароль",
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Підтвердіть пароль";
                      }
                      if (value != passwordController.text) {
                        return "Паролі не збігаються";
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppStyles.secondaryColor,
                    ),
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  CustomButton(
                    text: "Змінити пароль",
                    onPressed: resetPassword,
                    isLoading: isLoading,
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Повернутися до входу",
                        style: TextStyle(
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
