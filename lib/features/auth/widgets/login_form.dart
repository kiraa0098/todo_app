import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/common/helper/secure_storage_helper.dart';
// Removed unused imports
import 'package:todo_app/common/widgets/snackbar/floating_snackbar.dart';
import 'package:todo_app/features/auth/api/login_api.dart';
import 'package:todo_app/features/auth/models/login_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _isLoading = true);
    try {
      final loginModel = LoginModel(email: email, password: password);
      final response = await LoginApi.login(loginModel);
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']?['token'] as String?;
        final user = data['data']?['user'] as Map<String, dynamic>?;
        if (token != null && user != null) {
          await SecureStorageHelper.saveToken(token);
          await SecureStorageHelper.saveUserInfo(
            id: user['id'] ?? '',
            firstName: user['firstName'] ?? '',
            lastName: user['lastName'] ?? '',
            middleName: user['middleName'],
            suffix: user['suffix'],
            birthday: user['birthday'],
          );
          if (!mounted) return;
          FloatingSnackbar.show(
            context,
            'Login successful!',
            type: SnackbarType.success,
          );
          context.go('/');
        } else {
          FloatingSnackbar.show(
            context,
            'Login failed: Invalid response',
            type: SnackbarType.error,
          );
        }
      } else {
        FloatingSnackbar.show(
          context,
          'Login failed: ${response.body}',
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        FloatingSnackbar.show(context, 'Error: $e', type: SnackbarType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            decoration: inputDecoration.copyWith(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            autofillHints: const [AutofillHints.email],
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            decoration: inputDecoration.copyWith(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: !_isLoading
                    ? () => setState(() => _obscureText = !_obscureText)
                    : null,
              ),
            ),
            autofillHints: const [AutofillHints.password],
            enabled: !_isLoading,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
