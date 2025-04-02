import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_update.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_password.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  /// Builds a dialog that allows the user to change their password.
  ///
  /// The dialog contains a form with three fields: the current password, the
  /// new password, and the confirmation password. The form is validated when
  /// the user presses the update button. If the form is valid, the
  /// [ButtonUpdate] widget is responsible for updating the password.
  ///
  /// The dialog is a child of a [BlocBuilder] widget, which rebuilds the dialog
  /// when the [LoginState] changes. This is used to show an error message if
  /// the password update fails.
  ///
  /// The dialog is a [SingleChildScrollView], which allows it to be larger than
  /// the screen size if the user's password is very long.
  ///
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
                   Text(
                     AppLocalizations.of(context)!.change_password,
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
                          labelText: AppLocalizations.of(context)!.current_password,
                          validator: (value) {
                            final errorMessage = validateCurrentPassword(
                                value, context.read<LoginBloc>(), context);
                            if (errorMessage != null) {
                              return errorMessage;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        PasswordInput(
                          controller: _newPasswordController,
                          labelText:  AppLocalizations.of(context)!.new_password,
                          validator:(value) => validatePassword(value, context),
                        ),
                        const SizedBox(height: 12),
                        PasswordInput(
                          controller: _repeatPasswordController,
                          labelText:  AppLocalizations.of(context)!.confirmation_password,
                          validator: (value) => validateConfirmPassword(
                              value, _newPasswordController, context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ButtonUpdate(
                      formKey: _formKey,
                      newPasswordController: _newPasswordController,
                      oldPasswordController: _oldPasswordController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
