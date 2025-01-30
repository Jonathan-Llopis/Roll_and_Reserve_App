import 'package:flutter/material.dart';

class InputReservationText extends StatelessWidget {
  const InputReservationText(
      {super.key,
      required this.controller,
      required this.label,
      required this.icon,
      this.keyboardType,
      this.readOnly,
      required this.validator,
      this.onTap});

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final String? Function(String? p1)? validator;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
      ),
    );
  }
}
