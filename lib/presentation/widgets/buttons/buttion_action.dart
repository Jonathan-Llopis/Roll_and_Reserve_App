import 'package:flutter/material.dart';

/// Builds a customizable action button with an icon and label. 
/// 
/// The button is wrapped in a `GestureDetector` to handle tap events and 
/// changes the mouse cursor to a pointer when hovered over in a web 
/// environment using `MouseRegion`.
/// 
/// The button's appearance is determined by its icon, label, and color 
/// properties. The color is applied to the icon and text, and used to 
/// create a semi-transparent background and border.
/// 
/// Parameters:
/// - [icon]: The icon to display inside the button.
/// - [label]: The text label to accompany the icon.
/// - [color]: The primary color used for the icon, label, and decorations.
/// - [onTap]: The callback function executed when the button is tapped.

Widget buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}