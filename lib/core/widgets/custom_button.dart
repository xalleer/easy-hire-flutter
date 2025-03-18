import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  final double width;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.style,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(top: AppStyles.verticalSpacing),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? AppStyles.primaryButtonStyle,
        child:
            isLoading
                ? Container(
                  width: 24,
                  height: 24,
                  padding: EdgeInsets.all(2.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : Text(text, style: AppStyles.buttonTextStyle),
      ),
    );
  }
}
