import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6A11CB);
  static const Color secondaryColor = Color(0xFF2575FC);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;

  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white70,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle googleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static BoxDecoration containerDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF6A11CB),
        Color(0xFF2575FC),
      ],
    ),
  );

  static ButtonStyle elevatedButtonCancelStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[300],
    foregroundColor: textColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );

  static ButtonStyle elevatedButtonAcceptStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6A11CB),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );
}
