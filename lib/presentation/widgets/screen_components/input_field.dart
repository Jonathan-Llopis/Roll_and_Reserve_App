import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_reservation_text.dart';

/// Builds a form field with a label, icon, and optional tap callback.
///
/// The form field is decorated with a label and a border. It also has
/// an icon on the left side that can be used to trigger a tap callback.
///
/// The form field is validated using the [validator] passed to the
/// constructor. If the validation fails, the error message is displayed
/// below the form field.
///
/// If [onTap] is provided, the field is read-only and the icon is colored
/// with the primary color. Otherwise, the field is editable and the icon
/// is colored with the onSurface color with 0.6 opacity.
///
/// The form field is filled with the surface variant color with 0.3 opacity.
///
/// The form field is wrapped in a [Padding] widget with a vertical padding of
/// 2 and a horizontal padding of 20.
///
/// The form field is also wrapped in a [SizedBox] widget with a width of
/// double.infinity * 0.8.
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
