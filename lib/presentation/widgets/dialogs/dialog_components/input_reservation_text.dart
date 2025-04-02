import 'package:flutter/material.dart';

class InputReservationText extends StatelessWidget {
  const InputReservationText(
      {super.key,
      required this.style,
      required this.controller,
      required this.icon,
      this.keyboardType,
      this.readOnly,
      required this.validator,
      this.onTap});

  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final String? Function(String? p1)? validator;
  final VoidCallback? onTap;
  final InputDecoration style;
  @override
  /// Build a TextFormField with the provided controller, style, and
  /// validator. The TextFormField is wrapped in a Padding widget with
  /// a vertical padding of 12.0. If the [readOnly] parameter is true,
  /// the field is read-only. If the [keyboardType] parameter is provided,
  /// the field is given that keyboardType. If the [onTap] parameter is
  /// provided, the field is given that onTap callback.
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: style,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
      
      ),
    );
  }
}
