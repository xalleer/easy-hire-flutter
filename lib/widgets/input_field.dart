import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class InputField extends StatefulWidget {
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;

  const InputField({
    super.key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color:
                _focusNode.hasFocus
                    ? AppStyles.focusColor
                    : AppStyles.labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppStyles.spacing),
        TextField(
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: const BorderSide(
                color: AppStyles.borderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: const BorderSide(
                color: AppStyles.focusColor,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
          ),
        ),
      ],
    );
  }
}
