import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const TextInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  String? _defaultValidator(String? value) {
    if (validator != null) {
      return validator!(value);
    }
    if (isRequired && (value == null || value.isEmpty)) {
      return '$label cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: _defaultValidator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
