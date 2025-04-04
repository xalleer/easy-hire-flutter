import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class ChipDisplay extends StatelessWidget {
  final List<String> items;
  final Function(String) onDelete;
  final bool showDelete;

  const ChipDisplay({
    super.key,
    required this.items,
    required this.onDelete,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 15),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children:
            items.map((item) {
              return Chip(
                label: Text(item),
                backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: AppStyles.primaryColor),
                deleteIconColor: AppStyles.primaryColor,
                onDeleted: showDelete ? () => onDelete(item) : null,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              );
            }).toList(),
      ),
    );
  }
}
