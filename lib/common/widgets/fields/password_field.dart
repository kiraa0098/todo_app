import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _passwordValidator(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    if (value == null || value.isEmpty) {
      return '${widget.label} cannot be empty';
    }
    if (value.length < 6) {
      return '${widget.label} must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: _passwordValidator,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
