import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class ChipInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onAdd;
  final List<String> selectedItems;
  final Function(String) onDelete;
  final String labelText;
  final IconData icon;

  const ChipInput({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onAdd,
    required this.selectedItems,
    required this.onDelete,
    required this.labelText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          style: AppStyles.inputTextStyle,
          decoration: AppStyles.getInputDecoration(labelText).copyWith(
            prefixIcon: Icon(icon, color: AppStyles.secondaryColor),
            suffixIcon: IconButton(
              icon: Icon(Icons.add, color: AppStyles.primaryColor),
              onPressed: onAdd,
            ),
          ),
        ),
        if (selectedItems.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  selectedItems.map((item) {
                    return Chip(
                      label: Text(item),
                      backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppStyles.primaryColor),
                      deleteIconColor: AppStyles.primaryColor,
                      onDeleted: () => onDelete(item),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    );
                  }).toList(),
            ),
          ),
        TextButton.icon(
          onPressed: onCancel,
          icon: Icon(Icons.close, color: AppStyles.errorColor),
          label: Text(
            "Скасувати",
            style: TextStyle(color: AppStyles.errorColor),
          ),
        ),
      ],
    );
  }
}
