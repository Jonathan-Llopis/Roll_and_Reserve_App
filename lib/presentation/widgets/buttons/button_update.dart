import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonUpdate extends StatelessWidget {
  const ButtonUpdate({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController newPasswordController,
    required TextEditingController oldPasswordController,
  })  : _formKey = formKey,
        _newPasswordController = newPasswordController,
        _oldPasswordController = oldPasswordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _newPasswordController;
  final TextEditingController _oldPasswordController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style:AppTheme.textButtonCancelStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.validatePassword != null) {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(
                    UpdatePasswordEvent(password: _newPasswordController.text, oldPassword: _oldPasswordController.text));
                context.go('/login');
              }
            }
          },
          child: TextButton(
            style:AppTheme.textButtonAcceptStyle,
            onPressed: () {
              context.read<LoginBloc>().add(
                    ValidatePasswordEvent(
                      password: _oldPasswordController.text,
                    ),
                  );
            },
            child: Text(AppLocalizations.of(context)!.update),
          ),
        ),
      ],
    );
  }
}
