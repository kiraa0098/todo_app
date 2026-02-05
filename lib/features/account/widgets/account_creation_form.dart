import 'package:flutter/material.dart';
import 'package:todo_app/common/widgets/fields/email_field.dart';
import 'package:todo_app/common/widgets/fields/password_field.dart';
import 'package:todo_app/common/widgets/fields/text_input_field.dart';
import 'package:todo_app/common/widgets/snackbar/floating_snackbar.dart';
import 'package:todo_app/features/account/api/account_api.dart';
import 'package:todo_app/features/account/models/create_account_model.dart';

void showFloatingSnackbar(
  BuildContext context,
  String message, {
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    ),
  );
}

class AccountCreationForm extends StatefulWidget {
  const AccountCreationForm({super.key});

  @override
  State<AccountCreationForm> createState() => _AccountCreationFormState();
}

class _AccountCreationFormState extends State<AccountCreationForm> {
  bool _showPasswordInSummary = false;
  final _formKey = GlobalKey<FormState>();
  int _currentPhase = 1;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();

  DateTime? _selectedBirthday;
  final TextEditingController _birthdayController = TextEditingController();

  bool _isLoading = false;
  String? _responseMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    final createAccountModel = CreateAccountModel(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      middleName: _middleNameController.text.isEmpty
          ? null
          : _middleNameController.text,
      suffix: _suffixController.text.isEmpty ? null : _suffixController.text,
      birthday: _selectedBirthday,
    );

    try {
      final response = await AccountApi.createAccount(createAccountModel);
      if (!mounted) return;
      if (response.statusCode == 200) {
        FloatingSnackbar.show(
          context,
          'Account created!',
          type: SnackbarType.success,
        );
      } else {
        FloatingSnackbar.show(
          context,
          'Failed: ${response.body}',
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        FloatingSnackbar.show(context, 'Error: $e', type: SnackbarType.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _birthdayController.text = _selectedBirthday!
            .toLocal()
            .toString()
            .split(' ')[0];
      });
      _formKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed unused cappedWidth variable

    // Stepper indicator builder must be above usage
    Widget _buildStepCircle(int step) {
      final isActive = _currentPhase == step;
      final isCompleted = _currentPhase > step;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : isCompleted
              ? Colors.green[400]
              : Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stepper indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => _buildStepCircle(i + 1)),
                ),
              ),

              if (_currentPhase == 1) ...[
                TextInputField(
                  controller: _firstNameController,
                  label: 'First Name',
                  isRequired: true,
                ),
                const SizedBox(height: 14),
                TextInputField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  isRequired: true,
                ),
                const SizedBox(height: 14),
                TextInputField(
                  controller: _middleNameController,
                  label: 'Middle Name (optional)',
                  hintText: '',
                ),
                const SizedBox(height: 14),
                TextInputField(
                  controller: _suffixController,
                  label: 'Suffix (optional)',
                  hintText: '',
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _birthdayController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (_) {
                    if (_selectedBirthday == null) {
                      return 'Birthday cannot be empty';
                    }
                    return null;
                  },
                  onTap: () => _selectBirthday(context),
                ),
              ],

              if (_currentPhase == 2) ...[
                EmailField(controller: _emailController),
                const SizedBox(height: 14),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 14),
                PasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password cannot be empty';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],

              if (_currentPhase == 3) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[400]),
                          const SizedBox(width: 8),
                          Text(
                            'All set!',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildConfirmationSummary(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Your information is secure and will only be used for account creation.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              Row(
                children: [
                  if (_currentPhase > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => setState(() => _currentPhase--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPhase > 1) const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_currentPhase < 3) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _currentPhase++);
                                  }
                                } else {
                                  if (!_isLoading) _submit();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                _currentPhase < 3 ? 'Next' : 'Create Account',
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_responseMessage != null) ...[
                const SizedBox(height: 12),
                Text(_responseMessage!),
              ],
            ],
          ),
        ),
      ),
    );
    // (moved above usage)
  }

  Widget _buildConfirmationSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please review your information:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSummaryItem('First Name', _firstNameController.text),
        _buildSummaryItem('Last Name', _lastNameController.text),
        if (_middleNameController.text.isNotEmpty)
          _buildSummaryItem('Middle Name', _middleNameController.text),
        if (_suffixController.text.isNotEmpty)
          _buildSummaryItem('Suffix', _suffixController.text),
        _buildSummaryItem(
          'Birthday',
          _selectedBirthday?.toLocal().toString().split(' ')[0] ?? 'Not set',
        ),
        const Divider(),
        _buildSummaryItem('Email', _emailController.text),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Password'),
              Row(
                children: [
                  Text(
                    _showPasswordInSummary
                        ? _passwordController.text
                        : '••••••••',
                  ),
                  IconButton(
                    icon: Icon(
                      _showPasswordInSummary
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPasswordInSummary = !_showPasswordInSummary;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
