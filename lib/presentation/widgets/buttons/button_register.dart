import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonRegister extends StatelessWidget {
  const ButtonRegister(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.userNameController});

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController userNameController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isEmailUsed != null && state.isNameUsed != null) {
          if (state.isEmailUsed! || state.isNameUsed!) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.email_or_username_exists),
              ),
            );
          }
          if (formKey.currentState!.validate()) {
            context.read<LoginBloc>().add(ButtonRegisterPressed(
                email: emailController.text,
                password: passwordController.text,
                name: nameController.text,
                username: userNameController.text));
            context.go('/login');
          }
        }
      },
      child: ElevatedButton(
        onPressed: () {
          final loginBloc = context.read<LoginBloc>();
          loginBloc.add(IsEmailUserUsed(
              email: emailController.text, name: nameController.text));
        },
        style: AppTheme.elevatedButtonAcceptStyle,
        child:  Text(AppLocalizations.of(context)!.register, style: AppTheme.buttonStyle),
      ),
    );
  }
}
