import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/functions/show_dialogs.dart';

class DialogResetPassword extends StatefulWidget {
  const DialogResetPassword({super.key});

  @override
  State<DialogResetPassword> createState() => _DialogResetPasswordState();
}

class _DialogResetPasswordState extends State<DialogResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text("Recuperar contraseña",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Introduce tu email para restablecer tu contraseña',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'El email es obligatorio';
                }
                return null;
              },
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              context
                  .read<LoginBloc>()
                  .add(ResetPassword(email: emailController.text));
              Navigator.pop(context);
              mostrarResetEmail(context);
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
