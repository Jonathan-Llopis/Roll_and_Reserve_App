import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/validator_function.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/password_dialog_input.dart';

class DialogoUpdatePassword extends StatefulWidget {
  const DialogoUpdatePassword({super.key});

  @override
  State<DialogoUpdatePassword> createState() => _DialogoUserSettingsState();
}

class _DialogoUserSettingsState extends State<DialogoUpdatePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Cambiar Contraseña",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        PasswordInput(
                          controller: _oldPasswordController,
                          labelText: "Contraseña Actual",
                          validator: (value) {
                            final errorMessage = validateCurrentPassword(
                                value, context.read<LoginBloc>());
                            if (errorMessage != null ) {
                              return errorMessage;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        PasswordInput(
                          controller: _newPasswordController,
                          labelText: "Nueva Contraseña",
                          validator: validatePassword,
                        ),
                        const SizedBox(height: 12),
                        PasswordInput(
                          controller: _repeatPasswordController,
                          labelText: "Repite la Contraseña",
                          validator: (value) => validateConfirmPassword(
                              value, _newPasswordController),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                      BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state.validatePassword != null) {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(UpdatePasswordEvent(
                                  password: _newPasswordController.text));
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<LoginBloc>().add(
                                  ValidatePasswordEvent(
                                    password: _oldPasswordController.text,
                                  ),
                                );
                          },
                          child: const Text("Actualizar"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
