import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class AuthToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String leftLabel;
  final String rightLabel;

  const AuthToggle({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.leftLabel,
    required this.rightLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppStyles.verticalSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            leftLabel,
            style: AppStyles.toggleLabelStyle.copyWith(
              color:
                  !value
                      ? AppStyles.primaryColor
                      : AppStyles.textSecondaryColor,
            ),
          ),
          SizedBox(width: 10), // Adds a gap between the label and the switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppStyles.primaryColor,
          ),
          SizedBox(
            width: 10,
          ), // Adds a gap between the switch and the right label
          Text(
            rightLabel,
            style: AppStyles.toggleLabelStyle.copyWith(
              color:
                  value ? AppStyles.primaryColor : AppStyles.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
