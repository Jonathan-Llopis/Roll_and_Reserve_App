import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
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
  /// Builds the button to register a new user.
  ///
  /// This button is the default elevated button with the given style and
  /// child. When pressed, it adds [IsEmailUserUsed] to the [LoginBloc] with
  /// the email and name of the user. It then waits for the state to not be
  /// loading and checks if the email is used. If it is not used, it adds
  /// [ButtonRegisterPressed] to the [LoginBloc] with the email, password,
  /// name, and username of the user. It then navigates to the user's page.
  ///
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final loginBloc = context.read<LoginBloc>();
        loginBloc.add(IsEmailUserUsed(
            email: emailController.text, name: nameController.text));
            do {
              await Future.delayed(const Duration(milliseconds: 100));
            } while (loginBloc.state.isLoading);

            if (loginBloc.state.isEmailUsed != null &&
                formKey.currentState!.validate()) {
              loginBloc.add(ButtonRegisterPressed(
                  email: emailController.text,
                  password: passwordController.text,
                  name: nameController.text,
                  username: userNameController.text));
              if (context.mounted) {
                context.go('/user');
              }
            }
      },
      style: AppTheme.elevatedButtonAcceptStyle,
      child: Text(AppLocalizations.of(context)!.register,
          style: AppTheme.buttonStyle),
    );
  }
}
