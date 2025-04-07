import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_toggle.dart';
import '../constants/app_styles.dart';
import '../services/auth_api.dart';
import '../utils/validators.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+380 (00) 000-00-00');
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();

  bool isEmailLogin = true;
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (isEmailLogin) {
        final response = await authApi.loginEmailUser(
          email: emailController.text,
          password: passwordController.text,
        );

        if (response != null) {
          _showSuccessSnackBar("✅ Успішний логін через пошту");
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorSnackBar("❌ Логін не вдалося здійснити");
        }
      } else {
        final response = await authApi.loginPhoneUser(
          phone: phoneController.text,
          password: passwordController.text,
        );

        if (response != null) {
          _showSuccessSnackBar("✅ Успішний логін через телефон");
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorSnackBar("❌ Логін не вдалося здійснити");
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: AppBar(
          title: Text("Вхід", style: AppStyles.headingStyle),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                      "Раді вас знову бачити!",
                      style: AppStyles.headingStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppStyles.verticalSpacing),
                    if (isEmailLogin)
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
                    CustomTextField(
                      hintText: "Пароль",
                      controller: passwordController,
                      obscureText: true,
                      validator: Validators.passwordValidator,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppStyles.secondaryColor,
                      ),
                    ),
                    AuthToggle(
                      value: isEmailLogin,
                      onChanged: (value) {
                        setState(() {
                          isEmailLogin = value;
                        });
                      },
                      leftLabel: "Телефон",
                      rightLabel: "Пошта",
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text(
                          "Забули пароль?",
                          style: TextStyle(color: AppStyles.primaryColor),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: "Увійти",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      isLoading: isLoading,
                    ),
                    SizedBox(height: AppStyles.verticalSpacing * 2),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ще немає акаунту? ",
                            style: TextStyle(
                              color: AppStyles.textSecondaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              );
                            },
                            child: Text(
                              "Зареєструватися",
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
