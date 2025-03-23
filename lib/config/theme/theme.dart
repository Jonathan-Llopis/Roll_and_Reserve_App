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
  
 static ButtonStyle textButtonCancelStyle = TextButton.styleFrom(
  backgroundColor: Colors.red.withOpacity(0.1),
  foregroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20), // Borde más redondeado
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Más compacto
  minimumSize: const Size(0, 36), // Altura fija más pequeña
).copyWith(
  overlayColor: MaterialStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.red.withOpacity(0.2);
      }
      if (states.contains(MaterialState.hovered)) {
        return Colors.red.withOpacity(0.15);
      }
      return Colors.transparent;
    },
  ),
);

static ButtonStyle textButtonAcceptStyle = TextButton.styleFrom(
  backgroundColor: const Color(0xFF00695C).withOpacity(0.1),
  foregroundColor: const Color(0xFF00695C),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20), // Mismo radio que cancelar
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  minimumSize: const Size(0, 36), // Misma altura
).copyWith(
  overlayColor: MaterialStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(MaterialState.pressed)) {
        return const Color(0xFF00695C).withOpacity(0.2);
      }
      if (states.contains(MaterialState.hovered)) {
        return const Color(0xFF00695C).withOpacity(0.15);
      }
      return Colors.transparent;
    },
  ),
);
}
