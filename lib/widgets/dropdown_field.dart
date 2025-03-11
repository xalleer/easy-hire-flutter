import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class DropdownField extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const DropdownField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppStyles.spacing),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10),
            ],
          ),
          child: DropdownButtonFormField<String>(
            focusNode: _focusNode,
            value: widget.items.contains(widget.value) ? widget.value : null,
            onChanged: widget.onChanged,
            validator: widget.validator,
            items:
                widget.items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppStyles.menuItemColor,
                      ),
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((String item) {
                return Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // Чіткий колір вибраного елемента
                  ),
                );
              }).toList();
            },
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppStyles.iconColor,
              size: 24,
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            elevation: 8,
            menuMaxHeight: 200,
            itemHeight: 60,
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(
                  color: AppStyles.errorColor,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                borderSide: const BorderSide(
                  color: AppStyles.errorColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
