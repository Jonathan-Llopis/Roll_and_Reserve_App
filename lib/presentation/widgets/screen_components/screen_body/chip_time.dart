 import 'package:flutter/material.dart';

/// Builds a chip with an icon and a text above a centered hour.
///
/// The chip is a white container with a slight opacity and rounded
/// corners. The icon and text are centered and aligned to the top of the
/// chip. The hour is centered and aligned to the bottom of the chip.
/// The text style is set to a smaller font size and a medium weight, while
/// the hour style is set to a larger font size and a bold weight.
Widget buildTimeChip(IconData icon, String text, String hour) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            Text(
              hour,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

