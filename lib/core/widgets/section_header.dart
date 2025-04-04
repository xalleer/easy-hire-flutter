import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;

  const SectionHeader({super.key, required this.title, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title, style: AppStyles.labelStyle),
          Spacer(),
          if (onAdd != null)
            TextButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add, color: AppStyles.primaryColor),
              label: Text(
                "Додати",
                style: TextStyle(color: AppStyles.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
