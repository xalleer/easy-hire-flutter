import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../constants/app_styles.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/button.dart';

class SignUpScreen extends StatelessWidget {
  final String title;

  const SignUpScreen({super.key, required this.title});

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
            child: const SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? selectedRole;
  final List<String> roles = ['Робітник', 'Роботодавець'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const InputField(label: "Телефон", keyboardType: TextInputType.phone),
        const SizedBox(height: AppStyles.spacing),
        const InputField(label: "Пошта"),
        const SizedBox(height: AppStyles.spacing),
        const InputField(label: "Пароль", obscureText: true),

        const SizedBox(height: AppStyles.spacing),
        DropdownField(
          label: "Роль",
          value: selectedRole,
          items: roles,
          onChanged: (String? newValue) {
            setState(() {
              selectedRole = newValue;
            });
          },
          validator: (value) => value == null ? "Оберіть роль" : null,
        ),

        const SizedBox(height: AppStyles.spacing * 3),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Зареєструватися',
            isLoading: false,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
