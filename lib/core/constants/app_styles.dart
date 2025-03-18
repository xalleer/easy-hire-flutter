import 'package:flutter/material.dart';

class AppStyles {
  // Spacing
  static const EdgeInsets formPadding = EdgeInsets.all(24.0);
  static const double verticalSpacing = 20.0;
  static const double horizontalSpacing = 16.0;

  // Colors
  static const Color primaryColor = Color(0xFF4A6FE5);
  static const Color secondaryColor = Color(0xFF2E3A59);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF757575);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16.0,
    color: textPrimaryColor,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 16.0,
    color: textSecondaryColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle toggleLabelStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  );

  // Input Decoration
  static InputDecoration getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintTextStyle,
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorColor, width: 2.0),
      ),
      errorStyle: TextStyle(color: errorColor),
    );
  }
}
