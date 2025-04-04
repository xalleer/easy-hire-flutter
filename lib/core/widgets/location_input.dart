import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../constants/app_styles.dart';

class LocationInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSuggestionSelected;
  final Future<List<String>> Function(String) suggestionsCallback;
  final VoidCallback onCancel;
  final VoidCallback onAdd;
  final VoidCallback onAutoDetect;
  final bool isDetecting;

  const LocationInput({
    super.key,
    required this.controller,
    required this.onSuggestionSelected,
    required this.suggestionsCallback,
    required this.onCancel,
    required this.onAdd,
    required this.onAutoDetect,
    this.isDetecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: controller,
                  style: AppStyles.inputTextStyle,
                  decoration: AppStyles.getInputDecoration(
                    'Введіть місце роботи',
                  ).copyWith(
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppStyles.secondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: AppStyles.primaryColor),
                      onPressed: onAdd,
                    ),
                  ),
                ),
                suggestionsCallback: suggestionsCallback,
                itemBuilder:
                    (context, suggestion) => ListTile(
                      title: Text(suggestion),
                      leading: Icon(Icons.location_city),
                    ),
                onSuggestionSelected: onSuggestionSelected,
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.cancel, color: AppStyles.errorColor),
              onPressed: onCancel,
            ),
          ],
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: isDetecting ? null : onAutoDetect,
          icon: Icon(Icons.my_location),
          label:
              isDetecting
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("Визначаємо..."),
                    ],
                  )
                  : Text("Визначити автоматично"),
          style: AppStyles.primaryButtonStyle,
        ),
      ],
    );
  }
}
