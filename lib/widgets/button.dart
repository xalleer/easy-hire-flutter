import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
