import 'package:flutter/material.dart';


class DialogEmailSent extends StatelessWidget {
  const DialogEmailSent({super.key});

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        content: const Text(
          'Se ha enviado un correo a tu email para restablecer tu contraseña',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    }
  }

