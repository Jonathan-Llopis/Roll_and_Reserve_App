import 'package:flutter/material.dart';

class MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const MapControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
/// Builds a circular button with an icon, using the provided color and 
/// onPressed callback.
///
/// The button is decorated with a circular shape and a shadow effect.
/// It uses the IconButton widget with a filled style, applying the 
/// specified icon, color, and onPressed callback. The button's background
/// color has a slight opacity.
///
/// The decoration includes a surface color from the theme and a box shadow 
/// for a subtle elevation effect.

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: IconButton.filled(
        icon: Icon(icon),
        color: color,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
