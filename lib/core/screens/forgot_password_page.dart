import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/app_styles.dart';
import '../services/auth_api.dart';
import '../utils/validators.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+380 (00) 000-00-00');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();

  bool isEmailReset = true;
  bool isLoading = false;

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (isEmailReset) {
        final response = await authApi.requestPasswordResetEmail(
          email: emailController.text,
        );

        if (response != null) {
          _showSuccessSnackBar("✅ Інструкції надіслано на пошту");
          Navigator.pushNamed(
            context,
            '/verify_code',
            arguments: {
              'isEmailReset': true,
              'identifier': emailController.text,
            },
          );
        } else {
          _showErrorSnackBar("❌ Не вдалося надіслати запит");
        }
      }
    } catch (e) {
      _showErrorSnackBar("❌ Помилка: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        title: Text("Скинути пароль", style: AppStyles.headingStyle),
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
                    "Відновіть свій пароль",
                    style: AppStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing),
                  Text(
                    "Вкажіть вашу пошту або номер телефону, щоб отримати інструкції для скидання пароля.",
                    style: TextStyle(color: AppStyles.textSecondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  if (isEmailReset)
                    CustomTextField(
                      hintText: "Електронна пошта",
                      controller: emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppStyles.secondaryColor,
                      ),
                    )
                  else
                    CustomTextField(
                      hintText: "Номер телефону",
                      controller: phoneController,
                      validator: Validators.phoneValidator,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: AppStyles.secondaryColor,
                      ),
                    ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEmailReset = true;
                          });
                        },
                        child: Text(
                          "Пошта",
                          style: TextStyle(
                            color:
                                isEmailReset
                                    ? AppStyles.primaryColor
                                    : AppStyles.textSecondaryColor,
                            fontWeight:
                                isEmailReset
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEmailReset = false;
                          });
                        },
                        child: Text(
                          "Телефон",
                          style: TextStyle(
                            color:
                                !isEmailReset
                                    ? AppStyles.primaryColor
                                    : AppStyles.textSecondaryColor,
                            fontWeight:
                                !isEmailReset
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  CustomButton(
                    text: "Відправити код",
                    onPressed: resetPassword,
                    isLoading: isLoading,
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Back to login
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
