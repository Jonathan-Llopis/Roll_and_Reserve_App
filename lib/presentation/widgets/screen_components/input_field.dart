import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_reservation_text.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  VoidCallback? onTap,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  required BuildContext context,
}) {
  final theme = Theme.of(context);

  return SizedBox(
    width: double.infinity * 0.8,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: InputReservationText(
        controller: controller,
        icon: icon,
        onTap: onTap,
        readOnly: onTap != null,
        keyboardType: keyboardType,
        validator: validator,
        style: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          prefixIcon:
              Icon(icon, color: theme.colorScheme.primary.withOpacity(0.8)),
          labelStyle: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          label: Text(label),
        ),
      ),
    ),
  );
}
