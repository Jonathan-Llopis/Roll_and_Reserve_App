import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const PasswordInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
 
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordVisible = false;
  String? _errorText;

  @override
  /// Builds a TextFormField for entering a password.
  ///
  /// The form field is decorated with a label and a border. It also has
  /// an icon button on the right side that can be used to toggle the
  /// visibility of the password.
  ///
  /// The form field is validated using the [validator] passed to the
  /// constructor. If the validation fails, the error message is displayed
  /// below the form field.
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        errorText: _errorText,
      ),
      validator: (value) {
        if (widget.validator != null) {
          final error = widget.validator!(value);
          if (error != null) {
            setState(() {
              _errorText = error;
            });
            return error;
          }
        }
        setState(() {
          _errorText = null;
        });
        return null;
      },
    );
  }
}