import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class InputField extends StatefulWidget {
  final String label;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool obscureText;

  const InputField({
    super.key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _isObscured = widget.obscureText;
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
                    ? AppStyles.inputFocusBorder
                    : AppStyles.labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppStyles.spacing),
        TextField(
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppStyles.inputFieldFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: const BorderSide(
                color: AppStyles.inputBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: const BorderSide(
                color: AppStyles.inputFocusBorder,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppStyles.iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
