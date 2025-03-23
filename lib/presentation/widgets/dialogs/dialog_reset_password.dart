import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title:  Text( AppLocalizations.of(context)!.reset_password,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            AppLocalizations.of(context)!.enter_your_email_to_reset_password,
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
                decoration:  InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText:  AppLocalizations.of(context)!.email,
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator:(value) => basicValidation(value, context)),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          style:AppTheme.textButtonCancelStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child:  Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          style: AppTheme.textButtonCancelStyle,
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              context
                  .read<LoginBloc>()
                  .add(ResetPassword(email: emailController.text));
              Navigator.pop(context);
              mostrarResetEmail(context);
            }
          },
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ],
    );
  }
}
