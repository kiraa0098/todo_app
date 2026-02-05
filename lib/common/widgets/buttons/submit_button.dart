import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.text, required this.onPressed});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isRateLimited = false;

  void _handlePress() {
    if (_isRateLimited) return;
    setState(() => _isRateLimited = true);
    widget.onPressed();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isRateLimited = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isRateLimited ? null : _handlePress,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (_isRateLimited || states.contains(WidgetState.disabled)) {
              return Colors.grey.shade600;
            }
            return Theme.of(context).colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (_isRateLimited || states.contains(WidgetState.disabled)) {
              return Colors.white;
            }
            return Colors.white;
          }),
        ),
        child: Text(widget.text),
      ),
    );
  }
}
