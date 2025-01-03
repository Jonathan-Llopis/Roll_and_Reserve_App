
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isEmailUsed != null &&
            state.isNameUsed != null) {
          if (state.isEmailUsed! ||
              state.isNameUsed!) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                    'El email o nombre ya existe en la base de datos'),
              ),
            );
          }
          if (formKey.currentState!.validate()) {
            context
                .read<LoginBloc>()
                .add(RegisterButtonPressed(
                  email: emailController.text,
                  password: passwordController.text,
                  name: nameController.text,
                ));
            context.go('/login');
          }
        }
      },
      child: ElevatedButton(
        onPressed: () {
          final loginBloc =
              context.read<LoginBloc>();
          loginBloc.add(IsEmailUserUsed(
              email: emailController.text,
              name: nameController.text));
        },
        style: AppTheme.elevatedButtonAcceptStyle,
        child: const Text(
          'Register',
          style:AppTheme.buttonStyle
        ),
      ),
    );
  }
}
