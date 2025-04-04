import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants/app_styles.dart';
import '../services/auth_api.dart';

class VerifyCodePage extends StatefulWidget {
  final bool
  isEmailReset; // To determine if the code was sent via email or phone
  final String identifier; // Email or phone number used for reset

  const VerifyCodePage({super.key, required this.isEmailReset, required this.identifier});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();

  bool isLoading = false;

  Future<void> verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await authApi.verifyResetCode(
        identifier: widget.identifier,
        code: codeController.text,
      );

      if (response != null) {
        _showSuccessSnackBar("✅ Код підтверджено");
        Navigator.pushNamed(
          context,
          '/reset_password',
          arguments: {
            'identifier': widget.identifier,
            'code': codeController.text,
          },
        );
      } else {
        _showErrorSnackBar("❌ Неправильний код");
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
        title: Text("Підтвердження коду", style: AppStyles.headingStyle),
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
                    "Введіть код підтвердження",
                    style: AppStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing),
                  Text(
                    "Ми надіслали код на ${widget.isEmailReset ? 'вашу пошту' : 'ваш телефон'}: ${widget.identifier}",
                    style: TextStyle(color: AppStyles.textSecondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  CustomTextField(
                    hintText: "Код підтвердження",
                    controller: codeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Введіть код";
                      }
                      if (value.length < 4) {
                        return "Код має бути не менше 4 символів";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(
                      Icons.vpn_key_outlined,
                      color: AppStyles.secondaryColor,
                    ),
                  ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Logic to resend code (could call the same reset API)
                        _showSuccessSnackBar("✅ Код повторно надіслано");
                      },
                      child: Text(
                        "Надіслати код повторно",
                        style: TextStyle(color: AppStyles.primaryColor),
                      ),
                    ),
                  ),

                  SizedBox(height: AppStyles.verticalSpacing),

                  CustomButton(
                    text: "Підтвердити",
                    onPressed: verifyCode,
                    isLoading: isLoading,
                  ),

                  SizedBox(height: AppStyles.verticalSpacing * 2),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Back to forgot password
                      },
                      child: Text(
                        "Повернутися назад",
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
